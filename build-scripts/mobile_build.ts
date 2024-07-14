import { $, file } from "bun";

try {
  await $`flutter build appbundle --split-debug-info=build/app/outputs/symbols --obfuscate > ${
    file("build.log")
  }`;
  console.info("Building iOS IPA");
  await $`flutter build ipa --release --split-debug-info=build/ios/symbols --obfuscate > ${
    file("build.log")
  }`;
  console.info("Build complete");
} catch (e) {
  console.error("Build failed");
  console.error(e);
  
  process.exit();
}

// Update gh release with new build using gh cli
try {
  await $`gh release delete-asset main app-release.aab`;
  await $`gh release delete-asset main questkeeper.ipa`;
} catch (e) {
  console.warn("No assets to delete");
}

console.info("Uploading new assets to GitHub release");
await $`gh release upload main build/app/outputs/bundle/release/app-release.aab build/ios/ipa/questkeeper.ipa`;
console.info("Assets uploaded successfully");
