# Policy gates

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

Minimum gates:
- Authority gate: required ADAL/CDEL/ESAL level present.
- Scope gate: task is within approved scope.
- Backup gate: checkpoint exists for live core changes.
- Confidentiality gate: PCL handling compatible with target disclosure.
- External onboarding gate: external target metadata and ownership controls documented.

Outcomes:
- allow
- defer (prerequisites missing but recoverable)
- block (forbidden or out-of-authority)
