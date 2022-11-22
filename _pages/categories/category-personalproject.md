---
title: "개인 프로젝트"
layout: archive
permalink: categories/personalproject
author_profile: true
sidebar_main: true
---

{% assign posts = site.categories.personalproject %}
{% for post in posts %} {% include archive-single2.html type=page.entries_layout %} {% endfor %}