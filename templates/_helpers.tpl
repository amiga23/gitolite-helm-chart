{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "gitolite.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "gitolite.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "gitolite.claimname.ssh-keys" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s-ssh-keys" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "gitolite.claimname.git" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s-git" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
