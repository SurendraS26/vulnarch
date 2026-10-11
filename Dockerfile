FROM archlinux:latest
RUN pacman -Syu --noconfirm --needed \
      tigervnc \
      plasma-meta plasma-x11-session kwin-x11 konsole dolphin \
      xorg-xauth xorg-xrdb ttf-dejavu dbus \
    && pacman -Scc --noconfirm
RUN useradd -m user
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 5901
ENTRYPOINT ["/entrypoint.sh"]
