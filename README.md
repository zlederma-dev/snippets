# Purpose

This is a DevOps project. A complex application with many developers working on it needs a way to make quick, reliable changes. This project uses DevOps mentality and techniques to solve that problem for a microservice in an arbitrary CRUD application. 

# Technologies
| | Technology | Role |
|---|---|---|
| 🧪 | Cypress | E2E testing |
| 🐳 | Docker | Containerization |
| ⚙️ | GitHub Actions | CI/CD pipelines |
| 🏗️ | Terraform | Infrastructure as code |
| 📦 | ECR | Image registry |
| ☁️ | EC2 | Hosting |

# Summary
This project contains:
- the local development environment for a frontend microservice.
- containerization of the application with docker
- good coding practices such as linting/autoformatting/version control. 
- a github action to run cypress tests against the service in order to help validate a pr
- github actions to build/test/deploy the resulting docker image to AWS ECR 
- github action to stop the old container, pull the new one from ECR, and start it.
- Terraform to source control the EC2 instance hosting the application. 

# Local development

# CI/CD

### Raised PR 
workflow file: [`ci.yaml`](.github/workflows/ci.yaml)
```mermaid
flowchart LR
  U[User] -->|raises PR| GH[GitHub Repository]

  GH -->|triggers workflow| RUN[GitHub Actions Runner]

  RUN -->|runs tests against branch| PR[Pull Request]

  PR -->|approved| DEPLOY[Continue]
  PR -->|denied| BLOCK[Block]

  style U    fill:#E8EAF6,stroke:#3949AB,stroke-width:2px,color:#0D1B2A
  style GH   fill:#E3F2FD,stroke:#1976D2,stroke-width:2px,color:#0D1B2A
  style RUN  fill:#E8F5E9,stroke:#388E3C,stroke-width:2px,color:#0D1B2A
  style PR   fill:#FFF8E1,stroke:#F57C00,stroke-width:2px,color:#0D1B2A
  style DEPLOY fill:#E8F5E9,stroke:#2E7D32,stroke-width:2px,color:#0D1B2A
  style BLOCK  fill:#FFEBEE,stroke:#C62828,stroke-width:2px,color:#0D1B2A
```

### On Merge [`build.yaml`](.github/workflows/build.yaml)

```mermaid
flowchart LR
  U[User] -->|merges PR| GH[GitHub Repository]
  GH -->|triggers workflow| RUN[GitHub Actions Runner]
  RUN -->|build & push image| ECR[Amazon ECR]

  style U    fill:#E8EAF6,stroke:#3949AB,stroke-width:2px,color:#0D1B2A
  style GH   fill:#E3F2FD,stroke:#1976D2,stroke-width:2px,color:#0D1B2A
  style RUN  fill:#E8F5E9,stroke:#388E3C,stroke-width:2px,color:#0D1B2A
  style ECR  fill:#FFF8E1,stroke:#F57C00,stroke-width:2px,color:#0D1B2A
```
### Trigger Deployment
[`deploy.yaml`](.github/workflows/deploy.yaml)
```mermaid
flowchart LR
  U[User] -->|manually triggers deploy workflow| RUN[GitHub Actions Runner]
  RUN -->|instructs snippets server to pull latest image and restart container| EC2[EC2 Server] 

  style U    fill:#E8EAF6,stroke:#3949AB,stroke-width:2px,color:#0D1B2A
  style RUN  fill:#E8F5E9,stroke:#388E3C,stroke-width:2px,color:#0D1B2A
  style EC2  fill:#E3F2FD,stroke:#1976D2,stroke-width:2px,color:#0D1B2A
  ```

# Local development

# Scope
In the history of this project, there was a backend. Adding this backend added quite a bit of complexity to the whole project. While I learned a lot from this added complexity, I decided to go with the KISS (keep it simple stupid) mentality in software engineering. The purpose of this project is to demonstrate a full pipeline for one microservice, not to show handling multiple microservices in one repo, or to show more networking skills. Constraints. 