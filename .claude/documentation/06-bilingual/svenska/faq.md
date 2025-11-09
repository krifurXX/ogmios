# FAQ - Vanliga Frågor

[🇬🇧 English](../docs/08-faq/faq.md) | [🇸🇪 Svenska](10-FAQ.md)

---

## Allmänt

**Q: Vad är Ogmios?**  
A: Ett Personal AI Infrastructure (PAI) system byggt kring Claude Code med UFC, Skills, Hooks och Voice.

**Q: Behöver jag kunna programmera?**  
A: Grundläggande kunskap hjälper, men många delar fungerar out-of-the-box.

**Q: Kostar det något?**  
A: Ogmios är gratis (MIT), men ElevenLabs voice är valfritt (betaltjänst).

---

## Installation

**Q: Måste jag använda bun?**  
A: Nej, npm/yarn/pnpm fungerar också, men bun rekommenderas.

**Q: Fungerar det på Windows?**  
A: Ja, testat på macOS/Linux/Windows.

---

## UFC System

**Q: Hur vet systemet vilken context att ladda?**  
A: Via intent detection i UserPromptSubmit-hooken.

**Q: Kan jag skapa egna context-filer?**  
A: Ja! Se [UFC System](03-UFC-SYSTEMET.md).

---

## Skills

**Q: Måste jag välja skill manuellt?**  
A: Nej, automatisk aktivering baserat på uppgiftstyp.

**Q: Kan jag skapa egna skills?**  
A: Ja! Se [exempel](../examples/example-skill-engineering.md).

---

## Voice System

**Q: Måste jag använda röster?**  
A: Nej, helt valfritt.

**Q: Hur får jag voice IDs?**  
A: ElevenLabs Voice Library - välj röster du gillar.

---

## Felsökning

**Q: Hooks körs inte?**  
A: Kontrollera `chmod +x` på hook-filer och settings.json syntax.

**Q: Context laddas inte?**  
A: Verifiera att filer finns i `~/.claude/.claude/context/`.

---

**Tillbaka:** [README](01-README.md)
