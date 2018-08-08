# DevOps Pipeline

https://beta.linuxacademy.com/#/activities/take/445edae0-868a-4dcf-a785-b798e76cb3c8

CLOUD SERVER
Production Web Service
Private ip address of production webserver:
10.0.1.101  
Public ip address of production webserver:
35.173.202.103  

CLOUD SERVER
Staging Webserver
Private ip address of staging webserver:
10.0.1.35  
Public ip address of staging webserver:
18.212.132.72  

CLOUD SERVER
Public ip address of CI server:
204.236.247.201  
Private ip address of CI server:
10.0.1.162  


For this project
https://github.com/linuxacademy/devops-essentials-sample-app

https://github.com/craignicholson/devops-essentials-sample-app

Click on Branches....


JENKINS
http://204.236.247.201:8080/



----




Learning Activity Guide
close
DevOps Pipeline
In this exercise, we will perform a series of deployments using a sample DevOps pipeline. To do so, make sure you have a GitHub account so that you may access and/or download the documents needed for this.

Before we begin
Use the following link to get the sample application source code from GitHub. Once here, use the Forkbutton. If it does not create the fork automatically, select your account to make sure the files are forked to your repository. This way, we have our own version of the files that we can make changes to.

Set up a Continuous Integration Server
Now that we have our documents ready, select the Branches tab. We will have four different branches. These will control the code changes we will be deploying. We will not use all of them in this lab.

First, we need to head to the public CI server IP address provided by our lab. Put it into our search bar followed by :8080. This is the server port we will be using for this lab. We show up on a Jenkins installation and find the devops-essentials-sample waiting for us. Click on it.

On the menu on left side of the screen, select Configure. In here, we will set it up so that we reference the fork we created. Once in the configure section, select Branch Sources. Change the Project Repository to the URL of the fork we created. Select Save once the change is complete. Back on the main page, we will see that Jenkins is scanning and building the branches from the fork.

Create a Pull Request
Go back to our fork. In here, go to the Branches tab again. Each branch is already set up for our use.

The first branch we will use is the new-feature branch.

Using the provided public production webserver IP, enter it into a new tab. We get a page saying DevOps is great. Using the new-feature, we are going to change the page and have it say DevOps is awesome. Go back to our GitHub page. Next to the new-feature file, select New Pull Request.

Now we need to make sure our pull request is pulling from the correct area. In our new-request file, the base fork drop-down is set to the original GitHub fork. From this drop-down, select our personal fork. Once selected, everything will update.

Now, for the base dropdown, we need to make sure that it is connecting to the master branch. This is code that is ready to be deployed to production. Make sure that our compare drop-down is set to new-feature. Now our compare drop-down is going to the base branch, letting our new-features information become our new code to be deployed via the master.

If you scroll down, you will see the changes are displayed in a code comparison.

Once ready, select Create Pull Request. A new box appears. Under it, select Merge Pull Request, and then Confirm Merge.

Once confirmed, go back to the Jenkin's server. From the sidebar, select the devops-esentials-sample>>master. We are taken to a new page. Ignore the initial build. Select build now from the sidebar. A new build will begin.

When it gets to DeployToProd stage, it will pause and wait for our input. Hover over the section, and you will see Proceed and Abort.

To check and make sure we should proceed, we'll need the public version of the staging IP from our lab environment. Enter it into the search bar, and you will see a page that says DevOps is awesome, which means the code pull is working correctly.

Once we know that it is working correctly, go back and hover over the DeployToProd section and select Proceed. This will finish our upload. Refresh our tab for the production webserver IP. We see the updated text.

How to Roll-Back an Issue
Go back to our forked project.

Go to the branches tab. Here we will find a branch called broken-feature for us to test with. Select New pull request for the broken-feature.

We will change our forks again, setting the items up as we did before with minor changes. Set the base fork drop-down to our personal fork. Set the base dropdown to the master branch. Set the compare drop-down to broken-feature. This time, when we look at the bottom of the page, we will see that we have misspelled something. As we are doing this as a test, go ahead and hit Create pull request, then Merge Pull request, and finally Confirm Merge.

Go back to the Jenkins tab and build the deployment by selecting Build Now. Go ahead and select Proceed.

When we view our production webserver IP this time, instead of having our correct DevOps is awesome text, we find a misspelled word. To fix it, we need to roll back. From the left side of the build page, select the drop-down next to our previous build. From the list, select Replay and then Run. This will start a build based on our previous build.

While that is building, check the staging webserver IP. It has reverted back to the correct text. Great! Hover over the DeployToProd section, and Select Proceed.

Once updated, our production webserver IP will show the correct text, and we will have performed a successful rollback.

Review
Now you have the general knowledge of a DevOps pipeline. While this is a very general look at a pipeline, we now have an idea of how to set up a continuous integration server, create a pull request, and perform a rollback. Congratulations on finishing this lab!

