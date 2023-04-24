---
title: "[Beakjoon] Platinum 2"
layout: archive
permalink: tags/p2
author_profile: true
sidebar_main: true
---

{% assign posts = site.tags.P2 %}
{% for post in posts %} 
    {% include archive-single2.html type=page.entries_layout %}
{% endfor %}
