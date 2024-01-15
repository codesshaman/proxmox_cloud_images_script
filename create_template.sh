#!/bin/bash

# Check arguments
if [ $# -eq 0 ]; then
  echo "Write os name and version after script name"
  echo 'Use "make help" for reference'
  exit 1
fi

#Create template
#args:
# vm_id
# vm_name
# file name in the current directory
function create_template() {
    #Print all of the configuration
    echo "Creating template $2 ($1)"

    #Create new VM 
    #Feel free to change any of these to your liking
    qm create $1 --name $2 --ostype l26 
    #Set networking to default bridge
    qm set $1 --net0 virtio,bridge=vmbr0
    #Set display to serial
    qm set $1 --serial0 socket --vga serial0
    #Set memory, cpu, type defaults
    #If you are in a cluster, you might need to change cpu type
    qm set $1 --memory 1024 --cores 4 --cpu host
    #Set boot device to new file
    qm set $1 --scsi0 ${storage}:0,import-from="$(pwd)/$3",discard=on
    #Set scsi hardware as default boot disk using virtio scsi single
    qm set $1 --boot order=scsi0 --scsihw virtio-scsi-single
    #Enable Qemu guest agent in case the guest has it available
    qm set $1 --agent enabled=1,fstrim_cloned_disks=1
    #Add cloud-init device
    qm set $1 --ide2 ${storage}:cloudinit
    #Set CI ip config
    #IP6 = auto means SLAAC (a reliable default with no bad effects on non-IPv6 networks)
    #IP = DHCP means what it says, so leave that out entirely on non-IPv4 networks to avoid DHCP delays
    qm set $1 --ipconfig0 "ip6=auto,ip=dhcp"
    #Import the ssh keyfile
    qm set $1 --sshkeys ${ssh_keyfile}
    #If you want to do password-based auth instaed
    #Then use this option and comment out the line above
    #qm set $1 --cipassword password
    #Add the user
    qm set $1 --ciuser ${username}
    #Resize the disk to 8G, a reasonable minimum. You can expand it more later.
    #If the disk is already bigger than 8G, this will fail, and that is okay.
    qm disk resize $1 scsi0 8G
    #Make it a template
    qm template $1

    #Remove file when done
    rm $3
}


#Path to your ssh authorized_keys file
#Alternatively, use /etc/pve/priv/authorized_keys if you are already authorized
#on the Proxmox system
export ssh_keyfile=/root/id_rsa.pub
#Username to create on VM template
export username=apalrd

#Name of your storage
export storage=local-lvm

#The images that I've found premade
#Feel free to add your own

## Debian
debian() {
    case $1 in
        "debian10")
            wget "https://cloud.debian.org/images/cloud/buster/latest/debian-10-genericcloud-amd64.qcow2"
            create_template $vmnum "tmp-debian-10" "debian-10-genericcloud-amd64.qcow2"
            ;;
        "debian11")
            wget "https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-genericcloud-amd64.qcow2"
            create_template $vmnum "tmp-debian-11" "debian-11-genericcloud-amd64.qcow2"
            ;;
        "debian12")
            wget "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-genericcloud-amd64.qcow2"
            create_template $vmnum "tmp-debian-12" "debian-12-genericcloud-amd64.qcow2"
            ;;
        "debian13")
            wget "https://cloud.debian.org/images/cloud/trixie/daily/latest/debian-13-genericcloud-amd64-daily.qcow2"
            create_template $vmnum "tmp-debian-13" "debian-13-genericcloud-amd64-daily.qcow2"
            ;;
        "debiansid")
            wget "https://cloud.debian.org/images/cloud/sid/daily/latest/debian-sid-genericcloud-amd64-daily.qcow2"
            create_template $vmnum "tmp-debian-sid" "debian-sid-genericcloud-amd64-daily.qcow2" 
            ;;
        *)
            echo "This OS has no supported by script"
            ;;
    esac
}
## Ubuntu
ubuntu() {
    case $1 in
        "ubuntu2004")
            wget "https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64.img"
            create_template $vmnum "tmp-ubuntu-20-04" "ubuntu-20.04-server-cloudimg-amd64.img" 
            ;;
        "ubuntu2204")
            wget "https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img"
            create_template $vmnum "tmp-ubuntu-22-04" "ubuntu-22.04-server-cloudimg-amd64.img" 
            ;;
        "ubuntu2310")
            wget "https://cloud-images.ubuntu.com/releases/23.10/release/ubuntu-23.10-server-cloudimg-amd64.img"
            create_template $vmnum "tmp-ubuntu-23-10" "ubuntu-23.10-server-cloudimg-amd64.img"
            ;;
        *)
            echo "This OS has no supported by script"
            ;;
    esac
}
## Centos
centos() {
    case $1 in
        "centos7")
            wget https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2.xz
            xz -d -v CentOS-7-x86_64-GenericCloud.qcow2.xz
            create_template $vmnum "tmp-centos-7" "CentOS-7-x86_64-GenericCloud.qcow2"
            ;;
        "centos8")
            wget https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-GenericCloud-8.1.1911-20200113.3.x86_64.qcow2
            create_template $vmnum "tmp-centos-8" "CentOS-8-GenericCloud-8.1.1911-20200113.3.x86_64.qcow2"
            ;;
        "centos9")
            wget https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-20230116.0.x86_64.qcow2
            create_template $vmnum "tmp-centos-9" "CentOS-Stream-GenericCloud-9-20230116.0.x86_64.qcow2"
            ;;
        *)
            echo "This OS has no supported by script"
            ;;
    esac
}
## Fedora
fedora() {
    case $1 in
        "fedora37")
            wget https://download.fedoraproject.org/pub/fedora/linux/releases/37/Cloud/x86_64/images/Fedora-Cloud-Base-37-1.7.x86_64.raw.xz
            xz -d -v Fedora-Cloud-Base-37-1.7.x86_64.raw.xz
            create_template $vmnum "tmp-fedora-37" "Fedora-Cloud-Base-37-1.7.x86_64.raw"
            ;;
        "fedora38")
            wget "https://download.fedoraproject.org/pub/fedora/linux/releases/38/Cloud/x86_64/images/Fedora-Cloud-Base-38-1.6.x86_64.raw.xz"
            xz -d -v Fedora-Cloud-Base-38-1.6.x86_64.raw.xz
            create_template $vmnum "tmp-fedora-38" "Fedora-Cloud-Base-38-1.6.x86_64.raw"
            ;;
        *)
            echo "This OS has no supported by script"
            ;;
    esac
}
## Rocky Linux
rocky() {
    case $1 in
        "rocky8")
            wget "http://dl.rockylinux.org/pub/rocky/8/images/x86_64/Rocky-8-GenericCloud.latest.x86_64.qcow2"
            create_template $vmnum "tmp-rocky-8" "Rocky-8-GenericCloud.latest.x86_64.qcow2"
            ;;
        "rocky9")
            wget "http://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud.latest.x86_64.qcow2"
            create_template $vmnum "tmp-rocky-9" "Rocky-9-GenericCloud.latest.x86_64.qcow2"
            ;;
        *)
            echo "This OS has no supported by script"
            ;;
    esac
}
# VM number request
echo "Please, enter VM number:"
read vmnum

# Start script
echo "Start creation VM template $1 with number $vmnum"

# Lists of operation systems
debian_list=("debian10" "debian11" "debian12" "debian13" "debiansid")
ubuntu_list=("ubuntu2004" "ubuntu2204" "ubuntu2310")
centos_list=("centos7" "centos8" "centos9")
fedora_list=("fedora37" "fedora38")
rocky_list=("rocky8" "rocky9")

# Input check
if [[ " ${debian_list[@]} " =~ " $1 " ]]; then
    debian $1
elif [[ " ${ubuntu_list[@]} " =~ " $1 " ]]; then
    ubuntu $1
elif [[ " ${centos_list[@]} " =~ " $1 " ]]; then
    centos $1
elif [[ " ${fedora_list[@]} " =~ " $1 " ]]; then
    fedora $1
elif [[ " ${rocky_list[@]} " =~ " $1 " ]]; then
    rocky $1
else
    echo "Os name <$1> has no correct OS version"
    echo "or this version not supported by script"
    echo 'Use "make help" command for reference'
fi