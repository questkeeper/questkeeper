import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/categories/providers/categories_provider.dart';
import 'package:questkeeper/spaces/models/spaces_model.dart';
import 'package:questkeeper/spaces/providers/page_provider.dart';
import 'package:questkeeper/spaces/providers/spaces_provider.dart';
import 'package:questkeeper/task_list/providers/tasks_provider.dart';
import 'package:questkeeper/task_list/views/edit_task_bottom_sheet.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

const String geminiApiKey = "";

class VoiceCommandFAB extends ConsumerStatefulWidget {
  const VoiceCommandFAB({super.key});

  @override
  ConsumerState<VoiceCommandFAB> createState() => _VoiceCommandFABState();
}

class _VoiceCommandFABState extends ConsumerState<VoiceCommandFAB> {
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  String _lastWords = '';
  String _lastError = '';
  String _lastStatus = '';

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
  }

  final _model = GenerativeModel(
    model: 'gemini-2.0-flash-exp',
    apiKey: geminiApiKey,
    generationConfig: GenerationConfig(
      temperature: 0.7, // Lowered for more consistent results
      topK: 40,
      topP: 0.95,
      maxOutputTokens: 8192,
      responseMimeType: 'application/json',
      responseSchema: Schema(
        SchemaType.object,
        description: "Parse voice command into actionable data with context",
        enumValues: [],
        requiredProperties: ["data"],
        properties: {
          "data": Schema(
            SchemaType.object,
            enumValues: [],
            requiredProperties: ["feature", "action", "context"],
            properties: {
              "feature": Schema(
                SchemaType.string,
                enumValues: ["spaces", "categories", "tasks"],
              ),
              "action": Schema(
                SchemaType.string,
                enumValues: ["create", "edit", "delete"],
              ),
              "context": Schema(
                SchemaType.object,
                properties: {
                  "useCurrentSpace": Schema(SchemaType.boolean),
                  // "searchByName": Schema(SchemaType.boolean),
                  "filterById": Schema(SchemaType.boolean),
                  "id": Schema(SchemaType.integer),
                  "name": Schema(SchemaType.string),
                  "spaceType": Schema(
                    SchemaType.string,
                    enumValues: ["school", "work", "living_room"],
                  ),
                  "parentName":
                      Schema(SchemaType.string), // For categories/tasks
                  "newName": Schema(SchemaType.string), // For edit operations
                },
              ),
            },
          ),
        },
      ),
    ),
    systemInstruction: Content.system('''
You are an AI assistant that processes voice commands for a task management app.
Current context will be provided in JSON format containing all spaces, categories, and tasks.

Parse commands considering:
1. Context awareness
   - "Delete this space" should set useCurrentSpace: true
   - "Delete homework space" should set filterById: true and name: "homework"
   - "Create a task under school space" should set parentName: "school"
   - "Create a new school space" should set spaceType: "school" and name to "school"

2. Natural language understanding
   - Handle variations like "remove", "get rid of", "create new", "make a new", etc.
   - Understand context from phrases like "under", "in", "within", "for"

3. Smart defaults
   - Infer space type from context (e.g., "homework" suggests "school")
   - Use current space when context implies it

4. Required properties
  - When creating a space, include a spaceType, name, and notification times (default to {standard: [12, 24], prioritized: [48]}).
  - When editing a space, include the space ID in the response, and all updated properties

Example commands and interpretations:
- "Delete this space" → {feature: "spaces", action: "delete", context: {useCurrentSpace: true}}
- "Create a homework category" → {feature: "categories", action: "create", context: {name: "homework", spaceType: "school"}}
- "Add a task to the office space" → {feature: "tasks", action: "create", context: {parentName: "office"}}
- "Rename the school space to University" → {feature: "spaces", action: "edit", context: {filterById: true, name: "school", newName: "University", id: <passedIn>}}

Always prefer name-based operations over IDs when names are provided.
'''),
  );

  Future<Map<String, dynamic>> _getCurrentContext() async {
    final spaces = ref.read(spacesManagerProvider).value ?? [];
    final categories = ref.read(categoriesManagerProvider).value ?? [];
    final tasks = ref.read(tasksManagerProvider).value ?? [];
    final currentSpace = getCurrentSpace(
        ref, ref.watch(pageControllerProvider), AsyncValue.data(spaces));

    return {
      'spaces': spaces
          .map((s) => {
                'id': s.id,
                'title': s.title,
                'spaceType': s.spaceType,
                'notificationTimes': s.notificationTimes,
              })
          .toList(),
      'categories': categories
          .map((c) => {
                'id': c.id,
                'title': c.title,
                'spaceId': c.spaceId,
              })
          .toList(),
      'tasks': tasks
          .map((t) => {
                'id': t.id,
                'title': t.title,
                'categoryId': t.categoryId,
              })
          .toList(),
      'currentSpace': currentSpace?.toJson(),
    };
  }

  Future<void> _processVoiceCommand(String text) async {
    try {
      final context = await _getCurrentContext();
      final chat = _model.startChat();

      // First, send the context
      await chat.sendMessage(
          Content.text('Current context: ${json.encode(context)}'));

      // Then, send the command
      final response = await chat.sendMessage(Content.text(text));

      final jsonResponse = json.decode(response.text ?? "{}");
      final data = jsonResponse['data'];

      switch (data['feature']) {
        case 'spaces':
          await _handleSpacesCommand(data['action'], data['context'], context);
          break;
        case 'categories':
          // await _handleCategoriesCommand(
          //     data['action'], data['context'], context);
          break;
        case 'tasks':
          // await _handleTasksCommand(data['action'], data['context'], context);
          break;
      }
    } catch (e) {
      debugPrint('Failed to process command: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to process command: ${e.toString()}')),
      );
    }
  }

  Future<void> _handleSpacesCommand(
    String action,
    Map<String, dynamic> cmdContext,
    Map<String, dynamic> appContext,
  ) async {
    final spacesManager = ref.read(spacesManagerProvider.notifier);
    final spacesGlobalValue = ref.read(spacesManagerProvider).value;
    final spaces = appContext['spaces'] as List;

    // Helper to find space by name
    // Spaces? findSpaceByName(String name) {
    //   return spaces.firstWhere(
    //     (s) => s['title'] == name,
    //   );
    // }

    switch (action) {
      case 'create':
        final newSpace = Spaces(
          title: cmdContext['name'],
          spaceType: cmdContext['spaceType'] ?? 'office',
          notificationTimes: {
            "standard": [12, 24],
            "prioritized": [48],
          },
        );
        await spacesManager.createSpace(newSpace);
        break;

      case 'edit':
        Spaces? spaceToEdit;
        if (cmdContext['useCurrentSpace'] == true) {
          spaceToEdit = appContext['currentSpace'] != null
              ? Spaces.fromJson(appContext['currentSpace'])
              : null;
        } else if (cmdContext["filterById"] == true) {
          spaceToEdit =
              spacesGlobalValue?.firstWhere((s) => s.id == cmdContext['id']);
        }

        if (spaceToEdit != null) {
          final updatedSpace = Spaces(
            id: spaceToEdit.id,
            title: cmdContext['newName'] ?? spaceToEdit.title,
            spaceType: cmdContext['spaceType'] ?? spaceToEdit.spaceType,
            notificationTimes: json.decode(cmdContext['spaceType']) ??
                spaceToEdit.notificationTimes,
          );
          await spacesManager.updateSpace(updatedSpace);
        }
        break;

      case 'delete':
        Spaces? spaceToDelete;
        if (cmdContext['useCurrentSpace'] == true) {
          spaceToDelete = appContext['currentSpace'] != null
              ? Spaces.fromJson(appContext['currentSpace'])
              : null;
        } else if (cmdContext["filterById"] == true) {
          spaceToDelete =
              spacesGlobalValue?.firstWhere((s) => s.id == cmdContext['id']);
        }

        if (spaceToDelete != null) {
          await spacesManager.deleteSpace(spaceToDelete);
        }
        break;
    }
  }

  void _initializeSpeech() async {
    bool available = await _speechToText.initialize(
      onError: (error) {
        debugPrint('Speech recognition error: ${error.errorMsg}');
        setState(() {
          _lastError = error.errorMsg;
          _isListening = false;

          // Show error in UI
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Speech recognition error: ${error.errorMsg}'),
              duration: Duration(seconds: 10),
            ),
          );
        });
      },
      onStatus: (status) {
        debugPrint('Speech recognition status: $status');
        setState(() => _lastStatus = status);

        // If we get a "done" status but no words were recognized
        if (status == 'done' && _lastWords.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No speech detected. Please try again.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      debugLogging: true,
    );

    if (!available) {
      debugPrint('Speech recognition not available on this device');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Speech recognition not available on this device'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _listen() async {
    if (!_isListening) {
      try {
        setState(() => _lastWords = ''); // Reset last words

        bool available = await _speechToText.initialize();
        if (available) {
          setState(() => _isListening = true);
          await _speechToText.listen(
            onResult: (result) {
              setState(() {
                _lastWords = result.recognizedWords;
                debugPrint('Recognized words: ${result.recognizedWords}');
                debugPrint('Is final result: ${result.finalResult}');

                if (result.finalResult) {
                  _isListening = false;
                  if (_lastWords.isNotEmpty) {
                    _processVoiceCommand(_lastWords);
                  }
                }
              });
            },
            listenFor:
                Duration(seconds: 10), // Reduced from 30 to 10 for testing
            pauseFor: Duration(seconds: 2), // Reduced from 3 to 2 for testing
            partialResults: true,
            cancelOnError: true,
            listenMode: ListenMode
                .deviceDefault, // Changed from confirmation to device default
            localeId: 'en_US', // Explicitly set to English
          );
        }
      } catch (e) {
        debugPrint("Voice recognition failed: ${e.toString()}");
        setState(() => _isListening = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Voice recognition failed: ${e.toString()}'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      setState(() => _isListening = false);
      await _speechToText.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (_isListening || _lastWords.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _lastWords.isEmpty ? 'Listening...' : 'Heard: $_lastWords',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (_lastStatus.isNotEmpty)
                  Text(
                    'Status: $_lastStatus',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                if (_lastError.isNotEmpty)
                  Text(
                    'Error: $_lastError',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
              ],
            ),
          ),
        FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ],
    );
  }
}
