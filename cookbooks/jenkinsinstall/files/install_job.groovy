import jenkins.model.*
import hudson.plugins.git.*;

def scm = new GitSCM("https://github.com/basas/simplecicd.git")
scm.branches = [new BranchSpec("*/main")];

def flowDefinition = new org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition(scm, "Jenkinsfile")

def parent = Jenkins.instance
def job = new org.jenkinsci.plugins.workflow.job.WorkflowJob(parent, "simplecicd_build_and_publish")
job.definition = flowDefinition
parent.reload()
