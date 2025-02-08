#include "application.hpp"
#include "flutter/generated_plugin_registrant.h"

#include <string>
#include <flutter_linux/flutter_linux.h>

#ifdef GDK_WINDOWING_X11
#include <gdk/gdkx.h>
#endif

struct _MyApplication {
  GtkApplication parent_instance;
  char **dart_entrypoint_arguments;
};

G_DEFINE_TYPE(MyApplication, my_application, GTK_TYPE_APPLICATION)

static void my_application_activate(GApplication *application) {
  const auto *self = MY_APPLICATION(application);
  auto *window = GTK_WINDOW(
    gtk_application_window_new(GTK_APPLICATION(application))
  );

  bool use_header_bar = true;
  const std::string title_text = "Quest Keeper";

#ifdef GDK_WINDOWING_X11
  auto *screen = gtk_window_get_screen(window);

  if (GDK_IS_X11_SCREEN(screen)) {
    const gchar *wm_name = gdk_x11_screen_get_window_manager_name(screen);

    // Fucking GNOME
    if (strcmp(wm_name, "GNOME Shell") != 0) {
      use_header_bar = false;
    }
  }
#endif

  if (use_header_bar) {
    auto *header_bar = GTK_HEADER_BAR(gtk_header_bar_new());
    gtk_widget_show(GTK_WIDGET(header_bar));

    gtk_header_bar_set_title(header_bar, title_text.c_str());
    gtk_header_bar_set_show_close_button(header_bar, true);

    gtk_window_set_titlebar(window, GTK_WIDGET(header_bar));
  } else {
    gtk_window_set_title(window, title_text.c_str());
  }

  gtk_window_set_default_size(window, 1280, 720);
  gtk_widget_show(GTK_WIDGET(window));

  const auto project = fl_dart_project_new();
  fl_dart_project_set_dart_entrypoint_arguments(project, self->dart_entrypoint_arguments);

  FlView *view = fl_view_new(project);
  gtk_widget_show(GTK_WIDGET(view));
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));

  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  gtk_widget_grab_focus(GTK_WIDGET(view));
}

static gboolean my_application_local_command_line(GApplication *application, gchar ***arguments, int *exit_status) {
  MyApplication *self = MY_APPLICATION(application);

  // Strip out the first argument as it is the binary name.
  self->dart_entrypoint_arguments = g_strdupv(*arguments + 1);

  GError* error = nullptr;

  if (!g_application_register(application, nullptr, &error)) {
    g_warning("Failed to register: %s", error->message);
    *exit_status = 1;
    return true;
  }

  g_application_activate(application);
  *exit_status = 0;

  return true;
}

static void my_application_startup(GApplication *application) {
  // MyApplication* self = MY_APPLICATION(application);

  // Perform any actions required at application startup.

  G_APPLICATION_CLASS(my_application_parent_class)->startup(application);
}

// Implements GApplication::shutdown.
static void my_application_shutdown(GApplication *application) {
  // MyApplication* self = MY_APPLICATION(application);

  // Perform any actions required at application shutdown.

  G_APPLICATION_CLASS(my_application_parent_class)->shutdown(application);
}

static void my_application_dispose(GObject *object) {
  MyApplication *self = MY_APPLICATION(object);
  g_clear_pointer(&self->dart_entrypoint_arguments, g_strfreev);
  G_OBJECT_CLASS(my_application_parent_class)->dispose(object);
}

static void my_application_class_init(MyApplicationClass *klass) {
  G_APPLICATION_CLASS(klass)->activate = my_application_activate;
  G_APPLICATION_CLASS(klass)->local_command_line = my_application_local_command_line;
  G_APPLICATION_CLASS(klass)->startup = my_application_startup;
  G_APPLICATION_CLASS(klass)->shutdown = my_application_shutdown;
  G_OBJECT_CLASS(klass)->dispose = my_application_dispose;
}

static void my_application_init(MyApplication *self) {
}

MyApplication *my_application_new() {
  // Set the program name to the application ID, which helps various systems
  // like GTK and desktop environments map this running application to its
  // corresponding .desktop file. This ensures better integration by allowing
  // the application to be recognized beyond its binary name.
  g_set_prgname(APPLICATION_ID);

  return MY_APPLICATION(
    g_object_new(
      my_application_get_type(),
      "application-id", APPLICATION_ID,
      "flags", G_APPLICATION_NON_UNIQUE,
      nullptr));
}
