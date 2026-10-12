FROM archlinux:latest
RUN pacman -Syu --noconfirm --needed \
      wayvnc \
      plasma-desktop chromium konsole dolphin \
      ttf-dejavu dbus \
    && pacman -Scc --noconfirm
RUN useradd -m vulnarch
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 5901
ENTRYPOINT ["/entrypoint.sh"]
