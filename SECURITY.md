# Security Notice

This repository contains **intentionally vulnerable** Terraform and Kubernetes
manifests, used as fixtures for security scanning and compliance research.

- Fixtures target a local LocalStack emulator (`http://localhost:4566`), not a real cloud account.
- Do **not** apply the `terraform/insecure/` stack to a live AWS or Azure subscription.
- No real credentials, account identifiers, or secrets are committed to this repository.
