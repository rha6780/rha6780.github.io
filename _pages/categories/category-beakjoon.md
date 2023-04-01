---
title: "Beakjoon"
layout: archive
permalink: categories/beakjoon
author_profile: true
sidebar_main: true
---

{% assign entries_layout = page.entries_layout | default: 'list' %}
{% for post in posts %} 
    {% include archive-single2.html type=page.entries_layout %}
{% endfor %}
