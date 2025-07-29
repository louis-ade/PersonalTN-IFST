# PersonalTN-IFST
Quick configuration of a Tailscale infrastructure
# Securely Connect Your Devices with Tailscale on Azure

This project helps you create your own private network in the cloud using **Tailscale** and **Azure**, all set up automatically with **Terraform**. 
## What We're Building

We're going to create a simple yet powerful setup:

**Your Own Private Cloud Network:** We'll use Terraform to build a secure network and two virtual computers (called **Virtual Machines** or **VMs**) in Microsoft Azure.
**The Secure Gateway (Subnet Router):** One of these VMs will act as a "Subnet Router." This device lets your other Tailscale devices (like your laptop or phone) securely connect to any other devices in its Azure network—even if those other devices don't have Tailscale installed.
**The Secure Server (SSH Device):** The other VM will be set up with "Tailscale SSH." This is a super secure way to remotely log in and control your server without ever exposing it to the public internet.


## What You'll Need

Before you start, make sure you have these tools ready to go.

**A Tailscale Account:** It's free and easy to sign up. This is where you'll manage your private network.
**An Azure Subscription:** You'll need an active Azure account to create the virtual machines. Azure offers a free trial for new users.
**Terraform:** This is the tool that automates the entire process.
**Azure CLI:** The command-line tool that lets Terraform talk to your Azure account. [Install it and log in with `az login`](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli).
**An SSH Key Pair:** This is your digital key to securely log into the servers initially. If you don't have one, you can [create it easily](https://www.ssh.com/academy/ssh/keygen).


## Let's Get Started

Follow these steps to deploy your private network.


### Step 1: Set Up Your Secrets

We need to give Terraform two pieces of information so it can do its job: your **Tailscale API key** and the **path to your SSH keys**.

1.  **Generate a Tailscale API key** from your [Tailscale admin console](https://login.tailscale.com/admin/settings/keys). This key allows Terraform to add your new VMs to your private network.
2.  In your terminal, set the API key as an environment variable (this is the safest way to handle secrets):
    ```bash
    export TAILSCALE_API_KEY="tskey-..." # Replace tskey-... with your API key
    ```
3.  Open the `variables.tf` file in this project and update the `ssh_public_key_path` variable to point to your SSH key file.


### Step 2: Deploy Your Infrastructure

Now for the fun part! Terraform will take care of the rest.

1.  Open your terminal and go to the project directory.
2.  Run `terraform init` to set up the project.
3.  Run `terraform apply` to create all the resources in Azure. Terraform will show you a summary of everything it's about to build.
4.  Type `yes` to confirm, and Terraform will get to work. This might take a few minutes.



### Step 3: Connect to Your Servers

Once Terraform is finished, it will print out the addresses of your new VMs.

1.  **Install Tailscale** on your local computer from the [Tailscale downloads page](https://tailscale.com/download/).
2.  Log in with the same account you used for the API key.
3.  You can now securely connect to your new servers using their Tailscale IP address or hostname from the Terraform output:
    


### Step 4: Enable the Subnet Router

For the subnet router to work, you need to approve it in the Tailscale admin console.

1.  Go to the **Machines** tab in your Tailscale admin console.
2.  Find your "Subnet Router VM."
3.  Click the three dots next to its name, select **Edit route settings**, and toggle on the advertised route.



