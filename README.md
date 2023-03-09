# Proxmox Terraform provider for ComputeStacks

## Setup

### Create Terraform User

SSH into the proxmox host and run:

**Create the User and permissions**
```bash
pveum role add TerraformProv -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.CPU VM.Config.Cloudinit VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Monitor VM.PowerMgmt"
```

**Set the password**: This won't be used.
```bash
pveum user add terraform-prov@pve --password CHANGEME
```

**Update ACLs**:
```bash
pveum aclmod / -user terraform-prov@pve -role TerraformProv
```

**Create API Credentials**
```bash
pveum user token add terraform-prov@pve cstacks --privsep=0
```

Update the `terraform.tfvars` values as follows:

```
proxmox_api_token_id => full-tokenid
proxmox_api_token_secret => value
```

Are you using a self-signed certificate for proxmox? If yes, also adjust `proxmox_insecure_ssl` to true.

### Setup Proxmox Debian Template

SSH into the proxmox host and run the following commands, while taking care to change the following values to match your environment:

* `Name`: Replace `tmpl-debian-11`.
* `ID`: Replace `999`.
* `Disk Location`: Replace `local-lvm`.
* `Network Bridge`: Replace `vmbr0`.

```bash
wget https://f.cscdn.cc/file/cstackscdn/machine-images/debian-11-computestacks.qcow2
qm create 999 --name tmpl-debian-11 \
              --net0 virtio,bridge=vmbr0 \
              --ostype l26 \
              --cpu host \
              --boot c \
              --bootdisk scsi0 \
              --serial0 socket \
              --vga serial0 \
              --agent enabled=1
```

Import the disk and convert the virtual machine to a template.
```bash
qm importdisk 999 debian-11-computestacks.qcow2 local-lvm
qm set 999 --scsihw virtio-scsi-single \
           --scsi0 local-lvm:vm-999-disk-0,discard=on,iothread=1,ssd=1 \
           --ide2 local-lvm:cloudinit
qm template 999
```

## Configure

### Setup your parameters

* Copy `providers.tf.sample` to `providers.tf` and (optionally) uncomment the cloudflare section if you want DNS settings (see below).
* Copy `terraform.tfvars.sample` to `terraform.tfvars` and add all required parameters. _(You can see a list of all available options and help text in the file `variables.tf`)_.

#### Automated DNS Setup

We have provided an example cloudflare file (`dns_cloudflare.tf.sample`) that you can use to automate the provisioning of DNS records. You may also use that as a guide for use with your dns provider of choice. Alternatively, this terraform package will output the required DNS settings to `result/dns_settings.txt` after provisioning.

To enable automated cloudflare dns configuration:

1. Edit `providers.tf` and ensure the `required_providers` block includes `cloudflare`. _(There is an example in that file)._
2. Copy `dns_cloudflare.tf.sample` to `dns_cloudflare.tf`.
3. Generate an api token with Cloudflare that includes write permissions to the domain.
4. Add `cloudflare_api_token` and `cloudflare_account_id` to your `terraform.tfvars` file. The Account ID can be found on the main zone overview page in your cloudflare account _(scroll down)_.


### Run Terraform

* `terraform init` to install required modules.
* `terraform apply` to build your servers.
