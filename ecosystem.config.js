module.exports = {
  apps : [{
    name: 'API',
    script: 'web/main.dart.js',

    // Options reference: https://pm2.keymetrics.io/docs/usage/application-declaration/
    args: 'one two',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    env: {
      NODE_ENV: 'development'
    },
    env_production: {
      NODE_ENV: 'production'
    }
  }],

  deploy : {
    production : {
      user : 'ubuntu',
      key  : `${process.env.HOME}/.ssh/APLO.pem`,
      host : 'ubuntu@ec2-13-231-5-164.ap-northeast-1.compute.amazonaws.com',
      ref  : 'origin/feature/upgrade',
      repo : 'git@github.com:BOLT-Protocol/PBTxParser.git',
      path : '/etc/production/PBTxParser',
      'post-deploy' : 'pm2 reload ecosystem.config.js --env production'
    }
  }
};
