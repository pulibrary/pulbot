# pulbot

We no longer use pulbot, please [use Ansible Tower instead](https://github.com/pulibrary/pul-it-handbook/blob/main/services/deployment.md)!

pulbot is a robot that listens in slack for deployment commands.  It's built on the [Hubot](http://hubot.github.com) framework, and was originally generated with by [generator-hubot](https://github.com/github/generator-hubot).

## Configuration
* Apps are configured in [apps.json](apps.json).
* Users who can deploy are configured in [scripts/listener_middleware.coffee](scripts/listener_middleware.coffee).

## Deployment and troubleshooting
* pulbot is deployed on libruby-dev.princeton.edu using Capistrano (but because there is no Gemfile, you can't used `bundle exec` to deploy manually, you just need Capistrano installed locally).
* If pulbot doesn't answer to `pulbot ping`, then it probably needs to be restarted by redeploying it, or with `killall -HUP node` on libruby-dev.
* If pulbot is down it won't receive the event. It used to ack messages but at some point we updated and it doesn't do that anymore
* go to [github webhooks for the pulibrary org](https://github.com/organizations/pulibrary/settings/hooks/6570702); you can see all the events that have been fired recently.
  * you can redeliver these events through that UI in github
* heaven service could be down
  * you can try to hit the heaven box via the browser (VPN required); it redirects to the github page
  * heaven is on appdeploy.princeton.edu

### Public key problems
If deploying to a pre-ansible box, you must add heaven's public key to the deploy user's authorized_keys on the box that will be deployed to.

`curl https://raw.githubusercontent.com/pulibrary/princeton_ansible/master/keys/heaven.pub >> authorized_keys`

Ensure that your app's capfile deploys via https, not the git protocol. If switching from the git protocol, you'll need to delete the `./repo` directory or you'll get an error that looks like a problem with a public key.

## Using pulbot

### Sequence of events
1. Ask pulbot to deploy
2. pulbot sends deployment event to github
3. github POSTs that event to [heaven](https://github.com/pulibrary/heaven) via a hook set up in the pulibrary organization
4. heaven receives the event and runs the deployment

### Heaven and automatic deployment
[heaven](https://github.com/pulibrary/heaven) is a Rails app that we run locally to receive webhooks from Github (with an organization-wide webhook). Each app is configured with a Github auto-deployment integration that sends a webhook call to heaven when there is a CI success on new commits to master.

### pulbot and on-demand deployment using slack
Once an app is configured, you can deploy it in slack with the command:

```
$ pulbot deploy my_app to staging
```

Custom branches can be deployed:

```
$ pulbot deploy my_app/my_branch to staging
```

You can also deploy to other environments (like `production`) or deploy branches with CI failures by using `deploy!`.

### Updating pulbot
When you update pulbot's configuration, it needs to be redeployed, which you can do using pulbot:

```
$ pulbot deploy pulbot
```

## Running pulbot Locally

You can test your hubot by running the following, however some plugins will not
behave as expected unless the [environment variables](#configuration) they rely
upon have been set.

You can start pulbot locally by running:

    % bin/hubot

You'll see some start up output and a prompt:

    [Sat Feb 28 2015 12:38:27 GMT+0000 (GMT)] INFO Using default redis on localhost:6379
    pulbot>

Then you can interact with pulbot by typing `pulbot help`.

    pulbot> pulbot help
    pulbot animate me <query> - The same thing as `image me`, except adds [snip]
    pulbot help - Displays all of the help commands that pulbot knows about.
