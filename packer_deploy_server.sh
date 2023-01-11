packer init "packer/vmware/windows/server/2022"
packer build --only=vsphere-iso.windows-server-standard-dexp -var-file="packer/vmware/vsphere.pkrvars.hcl" "packer/vmware/windows/server/2022"

