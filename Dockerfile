FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update -y && apt install --no-install-recommends -y xfce4 xfce4-goodies tigervnc-standalone-server tigervnc-common novnc websockify sudo xterm init systemd snapd vim net-tools curl wget git tzdata
RUN apt update -y && apt install -y dbus-x11 x11-utils x11-xserver-utils x11-apps
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:mozillateam/ppa -y
RUN echo 'Package: *' >> /etc/apt/preferences.d/mozilla-firefox
RUN echo 'Pin: release o=LP-PPA-mozillateam' >> /etc/apt/preferences.d/mozilla-firefox
RUN echo 'Pin-Priority: 1001' >> /etc/apt/preferences.d/mozilla-firefox
RUN echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:jammy";' | tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox
RUN apt update -y && apt install -y firefox
RUN apt update -y && apt install -y xubuntu-icon-theme
RUN apt update -y && apt install -y tigervnc-tools || apt install -y expect
RUN mkdir -p /root/.vnc && echo "password" | vncpasswd -f > /root/.vnc/passwd && chmod 600 /root/.vnc/passwd
RUN touch /root/.Xauthority
EXPOSE 5901
EXPOSE 6080
CMD bash -c "if [ -n \"${VNC_PASSWORD}\" ]; then echo \"${VNC_PASSWORD}\" | vncpasswd -f > /root/.vnc/passwd && chmod 600 /root/.vnc/passwd; fi && vncserver -localhost no -geometry 1024x768 && websockify --web=/usr/share/novnc/ ${PORT:-6080} localhost:5901"
