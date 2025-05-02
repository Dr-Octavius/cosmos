# COSMOS
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
[![License](https://img.shields.io/badge/License-GPL%20v3-blue.svg?style=for-the-badge)](./LICENSE)

## Meaning
1. ☁️**C**_loud_
2. ⚙️**O**_rchestration_
3. </>**S**_cripts_ & 
4. 📦**M**_odules_ for 
5. 🌐**O**_pen_
6. 🛠️**S**_ystems_

## Purpose

**COSMOS** is a vendor-agnostic collection of infrastructure scripts for spinning up 
Cloud resrouces (Kubernetes clusters, etc.) across different cloud providers. 
Whether you’re using DigitalOcean, Civo, or another provider, you’ll find organized 
modules and scripts to get your environment running quickly. 

**COSMOS** was born out of the need to maintain clean coding practices and to foster
code reuse so as to mitigate transfer time between one cloud provider to another. The 
focus of Sefire has conventionally been on Kubernetes. However, non kubernetes scripts
can also be contributed to live in this parent folder.

## Overview

- **Purpose**: Provide a **single home** for various infrastructure definitions, scripts, and modules.
- **Philosophy**: Keep the scripts **modular**, **reusable**, and **cloud/provider agnostic**.
- **Structure**: Each provider (e.g., DigitalOcean, Civo) has its own directory under `lib/`. Common utilities and shared code live at the top level.

## Repository Structure

```bash
├── .idea
├── .terraform
│   ├── local
│   ├── staging
│   └── prod
└── lib
    ├── civo
    │   └── main.tf
    └── digitalocean
        └── main.tf
```

1. **`.idea/`:** Artifacts created by IDEs (like JetBrains). Typically excluded or ignored in production, but you may keep it if you want to share IDE settings with your team.
2. **`.terraform/`:** Directory where Terraform stores its state files and cache, if you’re using Terraform. This is often added to `.gitignore` to avoid committing state.
3. **`lib/`:** Parent folder for **all** your infrastructure modules or scripts.
   1. **`civo/`:** Contains `main.tf` to provision infrastructure on [Civo](https://www.civo.com/).
   2. **`digitalocean/`:** Contains `main.tf` to provision infrastructure on [DigitalOcean](https://www.digitalocean.com/).

## Usage

If you plan on using this repo to deploy your infrastructure, you can follow the below steps.

1. **Clone the Repo**
   ```bash
   git clone https://github.com/sefire-octopi/cosmos.git
   cd cosmos
   ```
2. Place selected infrastructure scripts into .terraform/main.tf
3. If you’re using Terraform, run:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```
   Make sure you have valid credentials (e.g., environment variables) for the target provider.

4. Edit `variables.tf` or your relevant `.tfvars` files to fit your requirements (region, cluster size, naming conventions, etc.).

## Contributing

1. **Fork** the repository and create a branch for your feature or bug fix.
2. **Open a Pull Request** describing your changes and the motivation behind them.
3. **Adhere to** any style or naming guidelines detailed in our [CONTRIBUTING.md](CONTRIBUTING.md)

## Roadmap

- **Additional Provider Support**: GCP, AWS, Azure, etc.
- **Common Modules** for networking, security groups, or shared resources.
- **CI/CD Integration** (e.g., GitHub Actions, GitLab CI) for automated testing and deployments.
- To add Documentation on proper sanitation procedures for dev environment (when the dev folder is used etc.)
- To add Documentation on how to scale to different locations for dev environment (primarily through the terraform script, no creation of new workspace on HCP Terraform)
- TO add Documentation on how dev is about creating the sanfbox, and individual teams will create the resources in their own repo devs. Resource Reqs are consolidated and placed in Staging in this repo
- Main logic is: Dev Envvironment created on demand. Dev creates more resources on this dev environment. Repo team decides resources required & opens issue on cosmos so that nodepool can be added in staging
- Terraform use is dependant on whether deployed resource has a lot of drift. If yes, do not use terraform to track state and use .yaml + GitOPs approach instead

## License

This repository is released under the [GNU General Purpose License V3](./LICENSE) (or whichever license you choose). See the `LICENSE` file for details.

## Created Resources
| Resources    | Dev                   | Staging                                                                              | Prod |
|--------------|-----------------------|--------------------------------------------------------------------------------------|------|
| k8s Cluster  | ```sefire-sgp1-dev``` | ```sefire-sgp1-staging```                                                            |      |
| k8s Nodepool | ```core-np```         | ```core-np```<br/>```prometheus-np```<br/>```jaeger-np```<br/>```elasticsearch-np``` |      |
| k8s Firewall |                       | ```sefire-sgp1-dev-firewall```                                                       |      |

## Contact
- **Maintainers**: [sefire-org](mailto:origin@sefire.org)
- **Issues**: Please open an [issue](./issues) for questions, bugs, or feature requests.

Thanks for using **cosmos**! We hope it streamlines your Kubernetes provisioning and multi-cloud infrastructure management.