import { $, file } from "bun";

// const platforms = ["windows", "linux", "macos"];
const platforms = ["macos"];

for (const platform of platforms) {
  try {
    console.info(`Building ${platform}`);
    await $`flutter build ${platform} --release --split-debug-info=build/app/outputs/symbols --obfuscate > ${
      file("build.log")
    }`;

    if (platform === "macos") {
      await $`zip -r build/macos/Build/Products/Release/QuestKeeper.app.zip build/macos/Build/Products/Release/questkeeper.app`;
    }

    try {
      await $`gh release delete-asset main questkeeper_${platform}.zip`;
    } catch (e) {
      console.warn(`No asset to delete for ${platform}`);
    }

    await $`gh release upload main build/${platform}/Build/Products/Release/QuestKeeper.app.zip > ${
      file("upload.log")
    }`;
  } catch (e) {
    console.error(`Failed to build ${platform}`);
    console.error(e);
  }
}
