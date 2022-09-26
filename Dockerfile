FROM debian
RUN apt update
RUN apt install -y openssh-client openssh-server sudo cron vim
RUN touch /usr/local/bin/black.list
COPY blacklist-hunter.sh /usr/local/bin/
# Copy hello-cron file to the cron.d directory
COPY blacklist-hunter.cron /etc/cron.d/blacklist-hunter.cron
# Give execution rights on the cron job
RUN chmod 0744 /etc/cron.d/blacklist-hunter.cron
# Apply cron job
RUN crontab /etc/cron.d/blacklist-hunter.cron
# Create the log file to be able to run tail
RUN touch /var/log/cron.log
# Run the command on container startup
# CMD cron && tail -f /var/log/cron.log
RUN groupadd -f basition
RUN useradd -rm -d /home/bastionuser -s /bin/bash -g basition -p bastionuser bastionuser
CMD ["cron", "-f"]