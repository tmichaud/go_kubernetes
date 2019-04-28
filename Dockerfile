FROM scratch
ADD password.minimal /etc/passwd
ENV PORT 8080
EXPOSE $PORT
USER 65534:65534
COPY --chown=65534:65534 app / 
CMD ["/app"]
