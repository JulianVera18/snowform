# **SNOWFORM**
**A Terraform-based framework for managing Snowflake infrastructure with YAML configurations**

Snowform is an open-source Terraform implementation for managing Snowflake. It uses modular components, similar to functions in programming, and leverages YAML configurations to enable scalable and maintainable resource management.

## **Dependencies**
- **Terraform (>=1.7.4)**
- **Key Pair Authentication** - A Snowflake user with **ACCOUNTADMIN** privileges  
  > _ACCOUNTADMIN is required to manage account-level configurations and ensure full control over Snowflake resources created via Terraform._


## **Installation**
1. **Install Terraform with Homebrew**
    ```sh
    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform
    ```

2. **Setup Key Pair Authentication** with a Snowflake user  
   > **ACCOUNTADMIN** is required to maintain resources at the account level.  
   Refer to [Snowflake Key Pair Authentication Guide](https://docs.snowflake.com/en/user-guide/key-pair-auth) for setup instructions.

3. **Clone or download the repository**
    ```sh
    git clone https://github.com/YOUR_REPO/Snowform.git
    cd Snowform
    ```

4. **Configure environment variables**  
   Define the following variables in your terminal or in `.bashrc/.zshrc`:
    ```sh
    export SNOWFLAKE_ORGANIZATION_NAME=<REDACTED>
    export SNOWFLAKE_ACCOUNT_NAME=<REDACTED>
    export SNOWFLAKE_USER=<REDACTED>
    export SNOWFLAKE_ROLE=<REDACTED>
    export SNOWFLAKE_PRIVATE_KEY=<REDACTED>
    export SNOWFLAKE_PRIVATE_KEY_PASSPHRASE=<REDACTED>
    export SNOWFLAKE_AUTHENTICATOR=JWT
    ```

> **🔴 NOTE:**
> Ensure that private keys are securely stored and not hardcoded in Terraform configurations.

---
## ⚡ How does it Work

Orchestrate your Snowflake infrastructure with simple YAML configurations — Snowform seamlessly translates them into Terraform resources, making deployment more efficient and manageable. Just define your Snowflake setup, and let Snowform handle the rest! 🎯

## **⭐ Features**
- **🏗️ Team-based Resource Management** - Organize Snowflake resources by teams.
- **📝 Template Support** - Define reusable patterns for consistent configurations.
- **🔐 Role-Based Access Control** - Enforces consistency and robust security in deploying RBAC efficiently with appropriate privilege granting to resources
- **🛠️ Admin vs. End-User Abstractions** - Distinguish infrastructure management responsibilities between admins and end-users, ensuring a streamlined and secure experience.
- **📊 Orchestration at YAML Config** - YAML-based configurations allow declarative orchestration of Snowflake resources, reducing manual effort and improving repeatability.
- **🌎 Terraform Workspaces for Config States & Environments** - Utilize Terraform workspaces to manage different team configurations and separate environments (e.g., Dev, Staging, Prod) effectively.

### **📊 Comparisons of input file types**
| Feature | YAML | HCL | JSON |
|---------|------|-----|------|
| **Readability** | ✅ High readability with clean syntax | ⚠️ Moderate with specific syntax rules | ❌ Less readable with strict syntax |
| **Maintainability** | ✅ Easy to update and manage | ⚠️ Requires HCL knowledge | ❌ Verbose and error-prone |
| **Reusability** | ✅ Supports anchors and aliases | ✅ Supports modules | ❌ No native reuse features |
| **Templates** | ✅ Native template support | ⚠️ Limited templating | ❌ No templating |
| **Learning Curve** | ✅ Minimal | ❌ Steep | ⚠️ Moderate |
| **Industry Adoption** | ✅ Widely used in DevOps | ⚠️ Mostly Terraform-specific | ⚠️ Technical barrier |
| **Security** | ✅ Less risk of hardcoding secrets | ⚠️ Requires best practices | ❌ Commonly hardcodes secrets |

## **Project Structure**
```plaintext
.
├── README.md
├── configs
│   ├── _examples
│   │   ├── account_roles.yaml
│   │   ├── database_roles.yaml
│   │   ├── databases.yaml
│   │   ├── schemas.yaml
│   │   └── warehouses.yaml
│   ├── admins
│   │   └── governance.yaml
│   └── templates
│       └── rbac
│           ├── hierarchy.yaml
│           └── privileges.yaml
├── main.tf
├── modules
│   └── snowflake
│       ├── resources
│       │   ├── account_roles
│       │   │   ├── account_roles.main.tf
│       │   │   ├── account_roles.outputs.tf
│       │   │   ├── account_roles.providers.tf
│       │   │   └── account_roles.variables.tf
│       │   ├── database_roles
│       │   │   ├── database_roles.main.tf
│       │   │   ├── database_roles.output.tf
│       │   │   ├── database_roles.providers.tf
│       │   │   └── database_roles.variables.tf
│       │   ├── databases
│       │   │   ├── databases.main.tf
│       │   │   ├── databases.outputs.tf
│       │   │   ├── databases.providers.tf
│       │   │   └── databases.variables.tf
│       │   ├── schemas
│       │   │   ├── schemas.main.tf
│       │   │   ├── schemas.outputs.tf
│       │   │   ├── schemas.providers.tf
│       │   │   └── schemas.variables.tf
│       │   └── warehouses
│       │       ├── warehouses.main.tf
│       │       ├── warehouses.outputs.tf
│       │       ├── warehouses.providers.tf
│       │       └── warehouses.variables.tf
│       ├── resources.main.tf
│       ├── resources.output.tf
│       ├── resources.providers.tf
│       └── resources.variables.tf
├── outputs.tf
├── terraform.auto.tfvars
└── variables.tf
```
## ⭐ Usage Examples

### 1. YAML structure
```yaml
snowflake:
  templates:
    <re-usable-content>
  resources:
    # warehouse is an account-level object
    warehouses:
      - name: <warehouse-name>
        <warehouse-parameters>
    # database is an account-level object
    databases:
      - name: <database-name>
        <database-parameters>
        # schemas are contained (nested) within database object
        schemas:
        - name: <schema-name>
          <schema-parameters>

```
### 2. An example that deploys *GOVERNANCE* snowflake resources
#### governance.yaml
```yaml
snowflake:
  resources:
    # ----------------------
    # WAREHOUSES
    # ----------------------
    warehouses:
      - name: GOVERNOR_WH
        comment: Warehouse used for governance and auditing tasks.
        warehouse_size: SMALL
        min_cluster_count: 1
        max_cluster_count: 2
        scaling_policy: STANDARD
        auto_suspend: 300
        auto_resume: true
        statement_timeout_in_seconds: 3600
    # ----------------------
    # DATABASES
    # ----------------------
    databases:
      - name: GOVERNANCE
        comment: Centralized database for governance, audit, and compliance logs.
        data_retention_time_in_days: 7
        # ----------------------
        # SCHEMAS
        # ----------------------
        schemas:
          - name: AUDIT
            comment: Stores audit logs, GDPR compliance data, and security events.
          - name: MONITORING
            comment: Contains logs, alerts, and notifications for system monitoring.
            data_retention_time_in_days: 10

      - name: TOOLS
        comment: Shared utility database for storing Snowflake functions and tools.
        schemas:
          - name: TASKS
            comment: Contains all Data Engineering-related scheduled tasks.
            is_transient: true
          - name: UTILITIES
            comment: Stores shared utilities, functions, and reusable components.
```

### 3. Database Roles and Privilege Matrix
#### privileges.yaml
This typically is transposed but for visibility sake. Privileges are within the scope of the object it's encapsulated by.
!> [!NOTE]
> ALL privileges, on_future, and on_all have been omitted for reasons
> listed here [https://github.com/Snowflake-Labs/terraform-provider-snowflake/blob/v1.0.2/docs/technical-documentation/grants_redesign_design_decisions.md]
```yaml
database:
  roles: [DBR_ADMIN, DBR_CREATOR, DBR_OPERATOR, DBR_VIEWER]
  privileges:
    USAGE: [DBR_VIEWER]
    MONITOR: [DBR_OPERATOR]
    MODIFY: [DBR_OPERATOR]
    CREATE DATABASE ROLE: [DBR_CREATOR]
    CREATE SCHEMA: [DBR_CREATOR]

schema:
  roles: [DBR_ETL, DBR_SECURITY, DBR_ML]
  privileges:
    USAGE: [DBR_VIEWER]
    MONITOR: [DBR_VIEWER]
    MODIFY: [DBR_OPERATOR]
    CREATE TABLE: [DBR_ETL]
    CREATE VIEW: [DBR_ETL]
    CREATE STAGE: [DBR_ETL]
    CREATE PIPE: [DBR_ETL]
    CREATE MASKING POLICY: [DBR_SECURITY]
    CREATE PASSWORD POLICY: [DBR_SECURITY]
    CREATE ROW ACCESS POLICY: [DBR_SECURITY]
    CREATE MODEL: [DBR_ML]
    CREATE MODEL MONITOR: [DBR_ML]
    CREATE SNOWFLAKE.ML.CLASSIFICATION: [DBR_ML]
    CREATE SNOWFLAKE.ML.FORECAST: [DBR_ML]
    CREATE SNOWFLAKE.ML.ANOMALY_DETECTION: [DBR_ML]
    CREATE SNOWFLAKE.ML.DOCUMENT_INTELLIGENCE: [DBR_ML]
    CREATE NOTEBOOK: [DBR_CREATOR]
    CREATE PACKAGES POLICY: [DBR_SECURITY]
    CREATE TAG: [DBR_SECURITY]
```

## 4. Snowflake Hierarchy Overview
#### hierarchy.yaml
With this structure role hierarchy can be visualized naturally
```yaml
database:
  roles: [DBR_ADMIN, DBR_CREATOR, DBR_OPERATOR, DBR_VIEWER]
  hierarchy:
    DBR_ADMIN: [DBR_CREATOR, DBR_OPERATOR, DBR_VIEWER]
    DBR_CREATOR: [DBR_ETL, DBR_SECURITY, DBR_ML]
    DBR_OPERATOR: [DBR_VIEWER]
    DBR_VIEWER: []
schema:
  roles: [DBR_ETL, DBR_SECURITY, DBR_ML]
  hierarchy:
    DBR_ETL: []
    DBR_SECURITY: []
    DBR_ML: []
```

# Roadmap
Snowform is actively evolving. Expect changes as we refine features and improve usability.
