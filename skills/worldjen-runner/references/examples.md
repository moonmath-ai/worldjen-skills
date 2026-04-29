# WorldJen Runner — Examples

## List backend and local runners

```bash
worldjen runner list --json
worldjen runner list --local --json
```

## Create + configure in one shot

```bash
worldjen runner create --name gpu-0
```

## Register an existing token

```bash
worldjen runner register --token <TOKEN> --name gpu-0
```

## Operate the service

```bash
worldjen runner install --name gpu-0
worldjen runner start --name gpu-0
worldjen runner status --name gpu-0
worldjen runner logs --name gpu-0 -n 100
worldjen runner logs --name gpu-0 -f       # stream
```

## Multiple runners on one host

```bash
worldjen runner register --token <TOKEN_1> --name gpu-0
worldjen runner register --token <TOKEN_2> --name gpu-1
worldjen runner list --local
```

Each instance gets its own `runner-{name}.conf` and `worldjen-runner@{name}` systemd service while sharing the venv and Hugging Face model cache.

## Troubleshooting

- `runner status` or `runner logs` fails on this host — runner service management requires Linux + systemd.
- Missing runner ID — list with `worldjen runner list --json`.
- Auth failure — confirm `WORLDJEN_API_KEY` is set or pass `--api-key`.
- After `runner delete`, you can re-run `runner create` on the same machine — local config and key are removed too.
