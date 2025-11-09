# FAQ - Frequently Asked Questions

[🇬🇧 English](10-FAQ.md) | [🇸🇪 Svenska](../docs/06-bilingual/svenska/faq.md)

---

## General

**Q: What is Ogmios?**  
A: A Personal AI Infrastructure (PAI) system built around Claude Code with UFC, Skills, Hooks, and Voice.

**Q: Do I need to know programming?**  
A: Basic knowledge helps, but many parts work out-of-the-box.

**Q: Does it cost money?**  
A: Ogmios is free (MIT), but ElevenLabs voice is optional (paid service).

---

## Installation

**Q: Must I use bun?**  
A: No, npm/yarn/pnpm work too, but bun is recommended.

**Q: Does it work on Windows?**  
A: Yes, tested on macOS/Linux/Windows.

---

## UFC System

**Q: How does the system know which context to load?**  
A: Via intent detection in the UserPromptSubmit hook.

**Q: Can I create my own context files?**  
A: Yes! See [UFC System](03-UFC-SYSTEM.md).

---

## Skills

**Q: Must I choose skills manually?**  
A: No, automatic activation based on task type.

**Q: Can I create my own skills?**  
A: Yes! See [example](../examples/example-skill-engineering.md).

---

## Voice System

**Q: Must I use voices?**  
A: No, completely optional.

**Q: How do I get voice IDs?**  
A: ElevenLabs Voice Library - choose voices you like.

---

## Troubleshooting

**Q: Hooks don't run?**  
A: Check `chmod +x` on hook files and settings.json syntax.

**Q: Context doesn't load?**  
A: Verify files exist in `~/.claude/.claude/context/`.

---

**Back:** [README](01-README.md)
