---
title: "Beakjoon"
layout: archive
permalink: categories/beakjoon
author_profile: true
sidebar_main: true
---

{% if paginator %}
  {% assign posts = paginator.posts %}
{% else %}
  {% assign posts = site.categories.beakjoon %}
{% endif %}

{% for post in posts %} {% include archive-single2.html type=page.entries_layout %} {% endfor %}

{% include paginator.html %}
