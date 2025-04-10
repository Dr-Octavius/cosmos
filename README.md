# cosmos

**C**loud 
**O**rchestration 
**S**cripts & 
**M**odules for 
**O**pen 
**S**ystems

Welcome to **cosmos** – a vendor-agnostic collection of infrastructure scripts for spinning up Kubernetes clusters and related components across different cloud providers. Whether you’re using DigitalOcean, Civo, or another provider, you’ll find organized modules and scripts to get your environment running quickly.

---

## Overview

- **Purpose**: Provide a **single home** for various infrastructure definitions, scripts, and modules.
- **Philosophy**: Keep the scripts **modular**, **reusable**, and **cloud/provider agnostic**.
- **Structure**: Each provider (e.g., DigitalOcean, Civo) has its own directory under `lib/`. Common utilities and shared code live at the top level.

---

## Repository Structure

```bash
├── .idea
├── .terraform
│   └── main.tf
└── lib
    ├── civo
    │   └── main.tf
    └── digitalocean
        └── main.tf
```

Here’s what each directory is for:

1. **`.idea/`:** Artifacts created by IDEs (like JetBrains). Typically excluded or ignored in production, but you may keep it if you want to share IDE settings with your team.

2. **`.terraform/`:** Directory where Terraform stores its state files and cache, if you’re using Terraform. This is often added to `.gitignore` to avoid committing state.

3. **`lib/`:** Parent folder for **all** your infrastructure modules or scripts.
   ##### List
   1. **`civo/`:** Contains `main.tf` to provision infrastructure on [Civo](https://www.civo.com/).
   2. **`digitalocean/`:** Contains `main.tf` to provision infrastructure on [DigitalOcean](https://www.digitalocean.com/).

---

## Usage

1. **Clone the Repo**
   ```bash
   git clone https://github.com/sefire-octopi/cosmos.git
   cd cosmos
   ```

2. **Navigate to a Provider**
    - Example: using the **DigitalOcean** scripts:
      ```bash
      cd lib/digitalocean
      ```
    - Or, for **Civo**:
      ```bash
      cd lib/civo
      ```

3. **Provision**
    - If you’re using Terraform, run:
      ```bash
      terraform init
      terraform plan
      terraform apply
      ``` 
      Make sure you have valid credentials (e.g., environment variables) for the target provider.

4. **Customize / Extend**
    - Edit `variables.tf` or your relevant `.tfvars` files to fit your requirements (region, cluster size, naming conventions, etc.).

---

## Contributing

1. **Fork** the repository and create a branch for your feature or bug fix.
2. **Open a Pull Request** describing your changes and the motivation behind them.
3. **Adhere to** any style or naming guidelines detailed in our [CONTRIBUTING.md](CONTRIBUTING.md)
---

## Roadmap

- **Additional Provider Support**: GCP, AWS, Azure, etc.
- **Common Modules** for networking, security groups, or shared resources.
- **CI/CD Integration** (e.g., GitHub Actions, GitLab CI) for automated testing and deployments.

---

## License

This repository is released under the [GNU General Purpose License V3](./LICENSE) (or whichever license you choose). See the `LICENSE` file for details.

---

## Contact

- **Maintainers**: [sefire-octopi](mailto:origin@sefire.org)
- **Issues**: Please open an [issue](./issues) for questions, bugs, or feature requests.

---

_Thanks for using **cosmos**! We hope it streamlines your Kubernetes provisioning and multi-cloud infrastructure management.