FROM archlinux:latest
ENV LANG=C.UTF-8
RUN pacman -Syu --noconfirm --needed \
    tigervnc novnc \
    plasma-meta plasma-x11-session kwin-x11 konsole dolphin \
    xorg-xauth xorg-xrdb ttf-dejavu dbus \
    && pacman -Scc --noconfirm
RUN useradd -m sonu
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh
EXPOSE 5901 6080
ENTRYPOINT ["entrypoint.sh"]
