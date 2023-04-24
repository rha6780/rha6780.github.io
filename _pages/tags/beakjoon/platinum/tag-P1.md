---
title: "[Beakjoon] Platinum 1"
layout: archive
permalink: tags/p1
author_profile: true
sidebar_main: true
---

{% assign posts = site.tags.P1 %}
{% for post in posts %} 
    {% include archive-single2.html type=page.entries_layout %}
{% endfor %}
