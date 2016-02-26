require "vestacp/api/version"
require 'faraday'
require 'json'

module Vestacp
  module Api

    class Client

      AVAILABLE_COMMANDS = %w[v-acknowledge-user-notification
v-activate-vesta-license
v-add-backup-host
v-add-cron-job
v-add-cron-reports
v-add-cron-restart-job
v-add-cron-vesta-autoupdate
v-add-database
v-add-database-host
v-add-dns-domain
v-add-dns-on-web-alias
v-add-dns-record
v-add-domain
v-add-firewall-ban
v-add-firewall-chain
v-add-firewall-rule
v-add-fs-archive
v-add-fs-directory
v-add-fs-file
v-add-mail-account
v-add-mail-account-alias
v-add-mail-account-autoreply
v-add-mail-account-forward
v-add-mail-account-fwd-only
v-add-mail-domain
v-add-mail-domain-antispam
v-add-mail-domain-antivirus
v-add-mail-domain-catchall
v-add-mail-domain-dkim
v-add-remote-dns-domain
v-add-remote-dns-host
v-add-remote-dns-record
v-add-sys-firewall
v-add-sys-ip
v-add-sys-quota
v-add-sys-sftp-jail
v-add-user
v-add-user-favourites
v-add-user-notification
v-add-user-package
v-add-user-sftp-jail
v-add-web-domain
v-add-web-domain-alias
v-add-web-domain-backend
v-add-web-domain-ftp
v-add-web-domain-httpauth
v-add-web-domain-proxy
v-add-web-domain-ssl
v-add-web-domain-stats
v-add-web-domain-stats-user
v-backup-user
v-backup-users
v-change-cron-job
v-change-database-host-password
v-change-database-owner
v-change-database-password
v-change-database-user
v-change-dns-domain-exp
v-change-dns-domain-ip
v-change-dns-domain-soa
v-change-dns-domain-tpl
v-change-dns-domain-ttl
v-change-dns-record
v-change-dns-record-id
v-change-domain-owner
v-change-firewall-rule
v-change-fs-file-permission
v-change-mail-account-password
v-change-mail-account-quota
v-change-mail-domain-catchall
v-change-remote-dns-domain-exp
v-change-remote-dns-domain-soa
v-change-remote-dns-domain-ttl
v-change-sys-config-value
v-change-sys-hostname
v-change-sys-ip-name
v-change-sys-ip-nat
v-change-sys-ip-owner
v-change-sys-ip-status
v-change-sys-language
v-change-sys-timezone
v-change-user-contact
v-change-user-language
v-change-user-name
v-change-user-ns
v-change-user-package
v-change-user-password
v-change-user-shell
v-change-user-template
v-change-web-domain-backend-tpl
v-change-web-domain-ftp-password
v-change-web-domain-ftp-path
v-change-web-domain-httpauth
v-change-web-domain-ip
v-change-web-domain-proxy-tpl
v-change-web-domain-sslcert
v-change-web-domain-sslhome
v-change-web-domain-stats
v-change-web-domain-tpl
v-check-fs-permission
v-check-user-password
v-check-vesta-license
v-copy-fs-directory
v-copy-fs-file
v-deactivate-vesta-license
v-delete-backup-host
v-delete-cron-job
v-delete-cron-reports
v-delete-cron-restart-job
v-delete-cron-vesta-autoupdate
v-delete-database
v-delete-database-host
v-delete-databases
v-delete-dns-domain
v-delete-dns-domains
v-delete-dns-domains-src
v-delete-dns-on-web-alias
v-delete-dns-record
v-delete-domain
v-delete-firewall-ban
v-delete-firewall-chain
v-delete-firewall-rule
v-delete-fs-directory
v-delete-fs-file
v-delete-mail-account
v-delete-mail-account-alias
v-delete-mail-account-autoreply
v-delete-mail-account-forward
v-delete-mail-account-fwd-only
v-delete-mail-domain
v-delete-mail-domain-antispam
v-delete-mail-domain-antivirus
v-delete-mail-domain-catchall
v-delete-mail-domain-dkim
v-delete-mail-domains
v-delete-remote-dns-domain
v-delete-remote-dns-domains
v-delete-remote-dns-host
v-delete-remote-dns-record
v-delete-sys-firewall
v-delete-sys-ip
v-delete-sys-quota
v-delete-sys-sftp-jail
v-delete-user
v-delete-user-backup
v-delete-user-backup-exclusions
v-delete-user-favourites
v-delete-user-ips
v-delete-user-notification
v-delete-user-package
v-delete-user-sftp-jail
v-delete-web-domain
v-delete-web-domain-alias
v-delete-web-domain-backend
v-delete-web-domain-ftp
v-delete-web-domain-httpauth
v-delete-web-domain-proxy
v-delete-web-domains
v-delete-web-domain-ssl
v-delete-web-domain-stats
v-delete-web-domain-stats-user
v-extract-fs-archive
v-generate-api-key
v-generate-password-hash
v-generate-ssl-cert
v-get-dns-domain-value
v-get-fs-file-type
v-get-mail-account-value
v-get-mail-domain-value
v-get-sys-timezone
v-get-sys-timezones
v-get-user-value
v-get-web-domain-value
v-insert-dns-domain
v-insert-dns-record
v-insert-dns-records
v-list-backup-host
v-list-cron-job
v-list-cron-jobs
v-list-database
v-list-database-host
v-list-database-hosts
v-list-databases
v-list-database-types
v-list-dns-domain
v-list-dns-domains
v-list-dns-domains-src
v-list-dns-records
v-list-dns-template
v-list-dns-templates
v-list-firewall
v-list-firewall-ban
v-list-firewall-rule
v-list-fs-directory
v-list-mail-account
v-list-mail-account-autoreply
v-list-mail-accounts
v-list-mail-domain
v-list-mail-domain-dkim
v-list-mail-domain-dkim-dns
v-list-mail-domains
v-list-remote-dns-hosts
v-list-sys-config
v-list-sys-cpu-status
v-list-sys-db-status
v-list-sys-disk-status
v-list-sys-dns-status
v-list-sys-info
v-list-sys-interfaces
v-list-sys-ip
v-list-sys-ips
v-list-sys-languages
v-list-sys-mail-status
v-list-sys-memory-status
v-list-sys-network-status
v-list-sys-rrd
v-list-sys-services
v-list-sys-shells
v-list-sys-users
v-list-sys-vesta-autoupdate
v-list-sys-vesta-updates
v-list-sys-web-status
v-list-user
v-list-user-backup
v-list-user-backup-exclusions
v-list-user-backups
v-list-user-favourites
v-list-user-ips
v-list-user-log
v-list-user-notifications
v-list-user-ns
v-list-user-package
v-list-user-packages
v-list-users
v-list-users-stats
v-list-user-stats
v-list-web-domain
v-list-web-domain-accesslog
v-list-web-domain-errorlog
v-list-web-domains
v-list-web-domains-alias
v-list-web-domains-proxy
v-list-web-domain-ssl
v-list-web-domains-ssl
v-list-web-domains-stats
v-list-web-stats
v-list-web-templates
v-list-web-templates-backend
v-list-web-templates-proxy
v-move-fs-directory
v-move-fs-file
v-open-fs-file
v-rebuild-cron-jobs
v-rebuild-databases
v-rebuild-dns-domain
v-rebuild-dns-domains
v-rebuild-mail-domains
v-rebuild-user
v-rebuild-web-domains
v-restart-cron
v-restart-dns
v-restart-ftp
v-restart-mail
v-restart-proxy
v-restart-service
v-restart-system
v-restart-web
v-restart-web-backend
v-restore-user
v-schedule-user-backup
v-schedule-user-restore
v-search-domain-owner
v-search-fs-object
v-search-object
v-search-user-object
v-start-service
v-stop-firewall
v-stop-service
v-suspend-cron-job
v-suspend-cron-jobs
v-suspend-database
v-suspend-database-host
v-suspend-databases
v-suspend-dns-domain
v-suspend-dns-domains
v-suspend-dns-record
v-suspend-domain
v-suspend-firewall-rule
v-suspend-mail-account
v-suspend-mail-accounts
v-suspend-mail-domain
v-suspend-mail-domains
v-suspend-remote-dns-host
v-suspend-user
v-suspend-web-domain
v-suspend-web-domains
v-sync-dns-cluster
v-unsuspend-cron-job
v-unsuspend-cron-jobs
v-unsuspend-database
v-unsuspend-database-host
v-unsuspend-databases
v-unsuspend-dns-domain
v-unsuspend-dns-domains
v-unsuspend-dns-record
v-unsuspend-domain
v-unsuspend-firewall-rule
v-unsuspend-mail-account
v-unsuspend-mail-accounts
v-unsuspend-mail-domain
v-unsuspend-mail-domains
v-unsuspend-remote-dns-host
v-unsuspend-user
v-unsuspend-web-domain
v-unsuspend-web-domains
v-update-database-disk
v-update-databases-disk
v-update-dns-templates
v-update-firewall
v-update-mail-domain-disk
v-update-mail-domains-disk
v-update-sys-ip
v-update-sys-ip-counters
v-update-sys-queue
v-update-sys-rrd
v-update-sys-rrd-apache2
v-update-sys-rrd-ftp
v-update-sys-rrd-httpd
v-update-sys-rrd-la
v-update-sys-rrd-mail
v-update-sys-rrd-mem
v-update-sys-rrd-mysql
v-update-sys-rrd-net
v-update-sys-rrd-nginx
v-update-sys-rrd-pgsql
v-update-sys-rrd-ssh
v-update-sys-vesta
v-update-sys-vesta-all
v-update-user-backup-exclusions
v-update-user-backups
v-update-user-counters
v-update-user-disk
v-update-user-package
v-update-user-quota
v-update-user-stats
v-update-web-domain-disk
v-update-web-domains-disk
v-update-web-domains-stat
v-update-web-domain-stat
v-update-web-domains-traff
v-update-web-domain-traff
v-update-web-templates]

      attr_reader :host, :user, :port, :default_account, :use_ssl, :verify_ssl

      def initialize(options={})
        @host = options[:host] || raise("No :host provided!")
        @user = options[:user] || raise("No :user provided!")
        @password = options[:password] || raise("No :password provided!")
        @default_account = options[:account] || nil
        @use_ssl = options[:use_ssl] || true
        @verify_ssl = true
        @verify_ssl = options[:verify_ssl] unless options[:verify_ssl].nil?
        @port = options[:port] || 8083
      end

      # v-list-mail-accounts USER DOMAIN [FORMAT]
      def post_command(command, options={}, *args)
        opts = {format: 'json', account: @default_account}.merge options

        if @use_ssl
          builder = URI::HTTPS
        else
          builder = URI::HTTP
        end

        uri = builder.build host: @host, port: @port #, path: "/api/"

        arguments_hash = {}
        ([args] + [opts[:format]]).flatten.each_with_index do |a, n|
          arguments_hash["arg#{n+1}".to_sym] = a
        end

        conn = Faraday.new(url: uri.to_s, ssl: {verify: @verify_ssl}) do |faraday|
          faraday.request :url_encoded # form-encode POST params
          #faraday.response :logger                  # log requests to STDOUT
          faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
        end

        post_hash = {user: self.user, password: @password, cmd: command}.merge(arguments_hash)
        response = conn.post '/api/', post_hash

        JSON.parse(response.body) if opts[:format].downcase.to_s == 'json'
      end

      def list_mail_accounts(domain, options={})
        opts = options.clone
        account = opts.delete(:account) || @default_account
        post_command 'v-list-mail-accounts', opts || {}, account, domain
      end

      def list_mail_account(domain, mail_account, options={})
        opts = options.clone
        account = opts.delete(:account) || @default_account
        post_command 'v-list-mail-account', opts || {}, account, domain, mail_account
      end


      def list_mail_account_autoreply(domain, mail_account, options={})
        opts = options.clone
        account = opts.delete(:account) || @default_account
        post_command 'v-list-mail-account-autoreply', opts || {}, account, domain, mail_account
      end

      # v-list-mail-domains USER [FORMAT]
      def list_mail_domains(options={})
        opts = options.clone
        account = opts.delete(:account) || @default_account
        post_command 'v-list-mail-domains', opts || {}, account
      end


      private

      def valid_command_name?(command)
        AVAILABLE_COMMANDS.include? "v-#{command.dasherize}"
      end

    end


  end
end
