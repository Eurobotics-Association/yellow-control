# Backup and rollback

Author: F.M. Robert Vergnes / robert.vergnes@yahoo.fr
Assisted-by: ChatGPT: GPT-5.5 Thinking; Codex

Backup checkpoints are mandatory before live updates affecting core runtime behavior.

Required pattern:
1. create pre-change checkpoint
2. verify checkpoint integrity and discoverability
3. perform change
4. record post-change status and rollback handle

If checkpoint creation/verification fails, execution is deferred or blocked.
