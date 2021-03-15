#!/usr/bin/env fish

function error --argument message
	set_color red
    echo "❗️ $message"
	exit 1
end

# If the OCI CLI does not exist on this system, then exit
if not type -q oci
	error "OCI CLI not present"
end

if set -q $OCI_COMPARTMENT_ID
	error "OCI Compartment for DNS not set"
end

if set -q $DNS_ZONE
	error "DNS_ZONE env variable must be set to update OCI DNS"
end

# Certbot env vars in case they are needed for reference
echo "Certbot Domain: $CERTBOT_DOMAIN"
echo "Certbot Validation: $CERTBOT_VALIDATION"
#echo $CERTBOT_TOKEN
#echo $CERTBOT_REMAINING_CHALLENGES
#echo $CERTBOT_ALL_DOMAINS

echo "Creating ACME DNS entry"

set OCI_RECORD (
	oci dns record rrset patch \
	--compartment-id $OCI_COMPARTMENT_ID \
	--zone-name-or-id $DNS_ZONE \
	--domain "_acme-challenge.$CERTBOT_DOMAIN" \
	--rtype TXT \
	--items "[{\"rdata\":\"$CERTBOT_VALIDATION\",\"ttl\":15}]"
)

echo "DNS entry created"
#echo $OCI_RECORD | prettyjson

echo "Sleeping to wait for DNS propogation"
sleep 20

echo "Auth hook script complete!"
