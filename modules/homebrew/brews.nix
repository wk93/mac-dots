[
  "ios-deploy"
  # fastlane z brew, nie nixpkgs: nixpkgs trzyma 2.232.2 z zepsutym loginem
  # Apple ID (Olympus 404, fastlane#30199), fix dopiero w 2.240.0.
  "fastlane"
  "wix/brew/applesimutils"
  "render-oss/render/render"
  # rusty: bun run hotfix (cargo zigbuild na linux/amd64, asembler rav1e)
  "zig"
  "nasm"
  # rusty: lint workflowów GitHub Actions
  "actionlint"
  # rusty: wspólny cache kompilacji Rusta między worktree (gate agentów)
  "sccache"
]
