FROM archlinux:latest
RUN pacman -Syu --noconfirm --needed \
      tigervnc \
      plasma-desktop chromium konsole dolphin \
      ttf-dejavu dbus xorg-xauth xorg-xrdb \
    && pacman -Scc --noconfirm
RUN useradd -m vulnarch
RUN echo "vulnarch:vulnarch" | chpasswd
COPY config /config
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 5901
ENTRYPOINT ["/entrypoint.sh"]
