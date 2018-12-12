# Dockerfile for binder
FROM sagemath/sagemath:8.3
COPY --chown=sage:sage . ${HOME}/jeudetaquin
WORKDIR ${HOME}/SageWidgetExper
RUN sage -pip install sage_combinat_widgets
RUN sage -pip install .
