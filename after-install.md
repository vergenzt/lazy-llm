# Lazy LLM for Hermes installed

Enable it if you did not install with `--enable`:

```bash
hermes plugins enable lazy
```

Restart Hermes or the gateway after enabling.

In shared gateways, restrict `/lazy` to trusted users with Hermes slash-command access controls; runtime mode is process-local.

Commands:

- `/lazy [lite|full|ultra|off]`
- `/lazy-review [target]`
- `/lazy-audit [target]`
- `/lazy-debt`
- `/lazy-gain`
- `/lazy-help`

Bundled skills are available as `tech debt:lazy`, `tech debt:lazy-review`, `tech debt:lazy-audit`, `tech debt:lazy-debt`, `tech debt:lazy-gain`, and `tech debt:lazy-help`.
