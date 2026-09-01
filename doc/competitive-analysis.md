# Competitive Analysis

## Competitive Analysis 0901-2026

No single product fully covers the loop: **GitHub change → training script → AI voiceover → login to a demo environment → screen capture of the live product → muxed video**. Available solutions are either partial pipelines or assembled stacks.

### Closest end-to-end (GitHub → live app → narrated video)

These tools try to read a repo or PR, drive a real product, and produce a voiced video.

| Solution | What it does | Gap |
|---|---|---|
| [Foley](https://github.com/lukataylo/Foley) | Onboards from a GitHub repo + demo URL. Claude drafts Playwright steps, Playwright captures, ElevenLabs narrates, ffmpeg concatenates. PRs re-run only changed steps. | Closest match. Early open-source; needs Anthropic + ElevenLabs keys and a running app. |
| [PRessPlay](https://github.com/Arsh-S/pressplay) | GitHub Action: reads the PR diff, generates a Playwright script, records against a preview URL, posts MP4/GIF on the PR. | No built-in voiceover; login/credentials are the caller's problem. |
| [Showrunner](https://github.com/kadj-amoah/showrunner) | Brief → script → Playwright record → TTS (ElevenLabs/OpenAI) → muxed captioned MP4. | Not GitHub-native; requires a brief and a running product. |
| [AutoDemo](https://github.com/JZnebel/AutoDemo) / [Ultrademo](https://github.com/new-xp/ultrademo) | Claude Code skill: agent logs into the app, records a screencast, writes narration, TTS + Remotion render. | Strong capture + VO. GitHub change detection is manual (“tell the agent”), not automatic. |
| [demoreel](https://github.com/FrostyyOPP/demoreel) | YAML script (`say` + `do`) → ElevenLabs first (video timed to audio) → Playwright records → ffmpeg mux. | Best voice-first sync. Script is hand-written unless an agent writes the YAML. |
| [playwright-recast](https://github.com/ThePatriczek/playwright-recast) | Turns existing Playwright tests/traces into polished videos with ElevenLabs/OpenAI/Polly, zooms, and captions. | Best if e2e tests already exist. GitHub trigger is just CI. |

**Practical pick for “PR landed → training video”:** Foley or PRessPlay for GitHub glue, plus ElevenLabs (or demoreel’s voice-first timing) for narration.

### Coding-agent path (Cursor / Claude / Copilot)

A Cursor Cloud Agent can cover most of the agent half without a new product:

1. Trigger from GitHub (`@cursor` on a PR/issue, Automations, or the Cloud Agent API).
2. Read the diff / changelog and write a training script.
3. Call ElevenLabs, OpenAI TTS, Cartesia, or Azure `MAI-Voice-1` for the voiceover.
4. Use computer use to log into a demo environment (credentials as env secrets, not in the prompt).
5. Record the screen while a computer-use subagent walks the UI.
6. Mux with ffmpeg.

Cursor already uses this pattern for PR walkthrough artifacts (screenshots/videos on the PR). It does **not** include a house narrator, timed captions, intro/outro, or “only recapture the scenes this PR touched.” Those are added with Foley, Showrunner, Remotion, or ffmpeg.

The same pattern works with Claude Code (AutoDemo/Ultrademo skills) or GitHub Copilot Agent Skills + hooks (changelog videos with Foundry TTS + Remotion).

### SaaS that is close (human still drives the demo)

These produce training-quality video and AI voiceover, but they do not read GitHub or log into a demo environment on their own.

- **[Guidde](https://www.guidde.com)** — Magic Capture of clicks → script + 200+ AI voices. Strongest for L&D / support docs.
- **[Clueso](https://www.clueso.io)** — One recording → narrated product video + written SOP + translation.
- **Tella** — Recorder that auto-edits; more creator-tool than pipeline.
- **Arcade / Supademo / Scribe / Tango** — Interactive or step-by-step guides from a capture; less cinematic video.

An agent can record into Guidde or Clueso, but the vendor product is still “human or bot performs the flow, AI polishes.”

### GitHub → video, but not a live product demo

These read PRs or changelogs and make a motion-graphics explainer, not a screen capture of the app.

- **[HeyGen HyperFrames `/pr-to-video`](https://github.com/heygen-com/hyperframes)** — PR URL → animated diffs, narration, captions.
- **[ngram changelog-to-video](https://www.ngram.com/convert/changelog-to-video)** — Changelog markdown → storyboard + ElevenLabs/MiniMax VO.
- **[Pull Reviews](https://github.com/ambient-code/pull-reviews)** — GitHub Action: LLM review + TTS + Remotion of highlighted diffs, posted on the PR.

Useful for release recaps. They will not show the feature inside the product.

### Building blocks for a custom pipeline

| Stage | Common choices |
|---|---|
| GitHub trigger | GitHub Actions, Cursor Automations / `@cursor`, Copilot hooks, webhooks |
| Script from diff | Claude / GPT / Copilot on `gh pr diff` + issue body |
| Voiceover | ElevenLabs (best alignment), OpenAI TTS, Cartesia, Azure/Foundry, edge-tts (free) |
| Login + drive UI | Playwright, Stagehand, [Browserbase](https://www.browserbase.com) (session video + persistent login context), Cursor computer use |
| Capture | Playwright `recordVideo`, CDP screencast, Browserbase session recording, OS screen record |
| Mux / polish | ffmpeg, Remotion, WhisperX forced alignment, SRT captions |

**Credentials:** use a dedicated demo account in a secret store (GitHub Actions secrets, Cursor environment secrets, 1Password, Vault). Persistent Browserbase contexts or Playwright `storageState` avoid putting login in the published video. Recast-style pipelines can drop the login scene from the final cut.

### What to choose

- **Real product footage + voiceover, regenerated when GitHub changes** → Foley, or a Cursor/Claude agent + Playwright + ElevenLabs + ffmpeg. PRessPlay if a silent PR demo is enough and VO is added later.
- **Existing Playwright tests** → playwright-recast (or specreel) in CI. Lowest ongoing maintenance.
- **Training videos at volume, with a person or agent clicking through once** → Guidde or Clueso.
- **Changelog/PR explainer, not a product tour** → HeyGen HyperFrames or ngram.

The production-quality version of this design is almost always: **LLM writes a scene list from the PR → TTS first (so duration is known) → agent/Playwright performs those scenes in a seeded demo env → ffmpeg/Remotion mux**. Demoreel and Showrunner already encode that order; Foley and PRessPlay add the GitHub trigger.
