## About

These Fish Shell scripts provide hooks for Certbot allow use of Oracle Cloud Infrastructure (OCI) DNS for Certbot's DNS Challenges. The following requirements should be satisfied before using these scripts:

1. The OCI CLI must be installed and configured on your computer.
2. The Certbot CLI must be installed on your computer.
3. Your OCI user account must have the appropriate permissions to manage the OCI DNS service in the compartments (or tenancy) where DNS records reside.

## Using the Scripts

You will use standard Certbot CLI commands when using these hooks.  They will be supplied as inputs to the `certbot` command.

The script uses a few environment variables for interacting with the DNS Service:

1. `OCI_COMPARTMENT_ID` - Can be any comparment or the root tenancy.
2. `DNS_ZONE` - The DNS zone where the acme DNS record will be added for validation.

```
# CD to the directory with these scripts
cd ~/certbot-oci-hooks

# Set an ENV variable for the compartment ID
set -gx OCI_COMPARTMENT_ID "ocid1.tenancy.oc1..aaaa...uq3bgq"

# Set the DNS zone to add the record
set -gx DNS_ZONE "yourdomain.com" # change based on DNS Zone

# Run the certbot command -- test cert and dry run flags supplied for testing before you run
certbot certonly \
    --manual \
    --preferred-challenges=dns \
    --manual-auth-hook (pwd)/auth-hook.sh \
    --manual-cleanup-hook (pwd)/cleanup-hook.sh \
    --agree-tos \
    --email <your email address> \
    -d <your domain -- root domain, sub domain, or wildcard> \
    --test-cert \
    --dry-run
```