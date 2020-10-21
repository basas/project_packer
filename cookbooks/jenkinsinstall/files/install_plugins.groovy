import jenkins.model.*
import java.util.logging.Logger
def logger = Logger.getLogger("")
def installed = false
def initialized = false


def pluginParameter="trilead-api cloudbees-folder antisamy-markup-formatter jdk-tool structs workflow-step-api token-macro build-timeout credentials plain-credentials ssh-credentials credentials-binding scm-api workflow-api timestamper script-security workflow-support durable-task workflow-durable-task-step plugin-util-api font-awesome-api popper-api jquery3-api bootstrap4-api snakeyaml-api jackson2-api echarts-api display-url-api command-launcher bouncycastle-api ace-editor jquery-detached workflow-scm-step workflow-cps workflow-job checks-api junit matrix-project resource-disposer ws-cleanup ant mailer apache-httpcomponents-client-4-api workflow-basic-steps gradle pipeline-milestone-step pipeline-input-step pipeline-stage-step pipeline-graph-analysis pipeline-rest-api handlebars momentjs pipeline-stage-view pipeline-build-step pipeline-model-api pipeline-model-extensions jsch git-client git-server workflow-cps-global-lib branch-api workflow-multibranch pipeline-stage-tags-metadata pipeline-model-definition lockable-resources workflow-aggregator okhttp-api github-api git github github-branch-source pipeline-github-lib ssh-slaves matrix-auth pam-auth ldap email-ext goovy build-pipeline-plugin job-dsl ec2 ec2-fleet"
def plugins = pluginParameter.split()
logger.info("" + plugins)
def instance = Jenkins.getInstance()
def pm = instance.getPluginManager()
def uc = instance.getUpdateCenter()
plugins.each {
  logger.info("Checking " + it)
  if (!pm.getPlugin(it)) {
    logger.info("Looking UpdateCenter for " + it)
    if (!initialized) {
      uc.updateAllSites()
      initialized = true
    }
    def plugin = uc.getPlugin(it)
    if (plugin) {
      logger.info("Installing " + it)
        def installFuture = plugin.deploy()
      while(!installFuture.isDone()) {
        logger.info("Waiting for plugin install: " + it)
        sleep(3000)
      }
      installed = true
    }
  }
}
if (installed) {
  logger.info("Plugins installed, initializing a restart!")
  instance.save()
  instance.restart()
}
