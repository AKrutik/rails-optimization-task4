# Гипотеза

Все инструменты мониторинга показывают, что самой горячей точкой является главная страница, StoriesController#index.

В частности, заметное время занимает рендеринг partial-ов \_single_story.html.erb.

Рассмотрите гипотезу о том, что можно закешировать <%= render "articles/single_story", story: story %> в \_main_stories_feed.html.erb и это даст заметный эффект.

## Benchmarking до оптимизации

```
Benchmarking 127.0.0.1 (be patient).....done

Server Software:
Server Hostname:        127.0.0.1
Server Port:            3000

Document Path:          /
Document Length:        137084 bytes

Concurrency Level:      1
Time taken for tests:   19.019 seconds
Complete requests:      100
Failed requests:        0
Total transferred:      13750700 bytes
HTML transferred:       13708400 bytes
Requests per second:    5.26 [#/sec] (mean)
Time per request:       190.187 [ms] (mean)
Time per request:       190.187 [ms] (mean, across all concurrent requests)
Transfer rate:          706.06 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing:   134  190  61.3    176     398
Waiting:      134  190  61.3    176     398
Total:        134  190  61.3    176     398

Percentage of the requests served within a certain time (ms)
  50%    176
  66%    192
  75%    199
  80%    205
  90%    260
  95%    366
  98%    392
  99%    398
 100%    398 (longest request)
```

## Проверка гипотезы

Добавила кэширование `story` в `app/views/stories/_main_stories_feed.html.erb`

## Benchmarking после оптимизации

```
Benchmarking 127.0.0.1 (be patient).....done

Server Software:
Server Hostname:        127.0.0.1
Server Port:            3000

Document Path:          /
Document Length:        137084 bytes

Concurrency Level:      1
Time taken for tests:   5.803 seconds
Complete requests:      100
Failed requests:        0
Total transferred:      13750700 bytes
HTML transferred:       13708400 bytes
Requests per second:    17.23 [#/sec] (mean)
Time per request:       58.035 [ms] (mean)
Time per request:       58.035 [ms] (mean, across all concurrent requests)
Transfer rate:          2313.85 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing:    37   58  24.2     48     147
Waiting:       37   58  24.1     48     146
Total:         37   58  24.2     48     147

Percentage of the requests served within a certain time (ms)
  50%     48
  66%     53
  75%     58
  80%     72
  90%     84
  95%    128
  98%    141
  99%    147
 100%    147 (longest request)
```

## Выводы

Время загрузки страницы ускорилось в 3,2 раза
