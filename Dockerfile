FROM scratch

ENV PORT 8080
EXPOSE $PORT

COPY app /
CMD ["/app"]
