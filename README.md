**Script for initial cloud images on proxmox**

Thank's [apalrd](https://www.apalrd.net/posts/2023/pve_cloud/ "pve cloud script") for idea!

***How to use***

At first you need install make to your proxmox (login from root):

``apt install make``

After that you can clone this script to your root folder:

``git clone https://github.com/codesshaman/proxmox_cloud_images_script.git``

And go to this folder:

``cd proxmox_cloud_images_script``

Now you can use make commands for installation:

``make help`` - get reference
``make debian13`` or ``make d13`` - install debian 13
``make centos9`` or ``make c9`` - install centos 9

etc...

All avalible linux distributions and commands you can see in ``make help`` reference.