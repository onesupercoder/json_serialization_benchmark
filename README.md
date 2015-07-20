# Benchmarking common (and not so common) Ruby JSON Serializers

This grew out of [a blog post](http://techblog.thescore.com/benchmarking-json-generation-in-ruby/), which wisely pointed that it's not all about the numbers in a benchmark: feature sets, maintainability and extensibility all must be weighed. If an app already has an approach, then the marginal effort of switching to a new approach should be weighed against the benefits. [Beauty is in the eye of the beholder](http://en.wikipedia.org/wiki/Lies,_damned_lies,_and_statistics).

The serializers measured include:
* [RABL](https://github.com/nesquena/rabl/)
* [ActiveModel Serializers](https://github.com/rails-api/active_model_serializers)
* Plain Ruby presenters
* [apiview](https://github.com/mindreframer/api_view) (a serializer by [chetan](https://github.com/chetan), [for comparison to other solutions](https://github.com/chetan/json_serialization_benchmark/tree/api_view/lib/api_view))
* [JBuilder](https://github.com/rails/jbuilder) (some trickery to get jbuilder rendering was drawn from [kirillplatonov's work](https://github.com/kirillplatonov/blog_content/blob/master/ams_vs_jbuilder/lib/tasks/benchmarks.rake))

## Setup

1. Clone the repo

        git clone git@github.com:phillbaker/json-serialization-benchmark.git

2. Change directory to json-serialization-benchmark

        cd json-serialization-benchmark

3. Install required gems

        bundle install

## Usage

* Run the benchmarks

        bundle exec ruby benchmark.rb

## Results

(Condensed to remove warmups and total iterations, run the benchmarks to see them.)

```
Using Ruby version: 2.1.5-p273


Member tests:


  Ultra Simple: Member      Iterations  Iterations  Comparison      Allocations   Memsize
                            (i/s)       (std dev %)

  Jbuilder 2.2.11              3.038k   ±20.4%      18.54x slower   181           8640
  RABL 0.11.6                  5.588k   ±12.1%      10.08x slower   97            6969
  AMS 0.9.3                   16.395k   ±11.6%      3.43x slower    63            1715
  ApiView                     50.835k   ±14.1%      1.11x slower    12            842
  Presenters                  56.311k   ±10.1%                      24            650


  Simple: Member            Iterations  Iterations  Comparison      Allocations   Memsize
                            (i/s)       (std dev %)

  RABL 0.11.6                  1.001k   ±16.0%      34.80x slower   534           44241
  Jbuilder 2.2.11              1.313k   ± 9.6%      26.51x slower   464           27536
  AMS 0.9.3                    6.218k   ±10.1%      5.60x slower    163           4863
  Presenters                  15.911k   ± 6.6%      2.19x slower    98            2918
  ApiView                     34.819k   ±16.1%                      15            1862


  Complex: Member           Iterations  Iterations  Comparison      Allocations   Memsize
                            (i/s)       (std dev %)

  RABL 0.11.6                498.237    ± 9.0%      43.66x slower   1130          101977
  Jbuilder 2.2.11            711.999    ± 8.0%      30.55x slower   829           52404
  AMS 0.9.3                    3.396k   ± 3.7%      6.41x slower    324           10026
  Presenters                   7.022k   ± 8.8%      3.10x slower    201           7395
  ApiView                     21.753k   ±18.7%                      17            3667



Collection tests:


  Ultra Simple: Collection  Iterations  Iterations  Comparison      Allocations   Memsize
                            (i/s)       (std dev %)

  RABL 0.11.6                 58.814    ±18.7%      46.91x slower   7660          648077
  Jbuilder 2.2.11             72.753    ±16.5%      37.92x slower   6433          517065
  AMS 0.9.3                  202.676    ±16.3%      13.61x slower   5333          150055
  Presenters                 637.420    ±15.4%      4.33x slower    3508          67594
  ApiView                      2.759k   ±26.4%                      112           46986


  Simple: Collection        Iterations  Iterations  Comparison      Allocations   Memsize
                            (i/s)       (std dev %)

  Jbuilder 2.2.11              8.338    ±12.0%      82.20x slower   61353         4277513
  RABL 0.11.6                 11.018    ±18.2%      62.21x slower   50964         4364195
  AMS 0.9.3                   65.849    ±15.2%      10.41x slower   15333         464855
  Presenters                 137.899    ±13.1%      4.97x slower    16108         380794
  ApiView                    685.397    ±26.6%                      610           148986


  Complex: Collection       Iterations  Iterations  Comparison      Allocations   Memsize
                            (i/s)       (std dev %)

  RABL 0.11.6                  4.801    ±20.8%      70.89x slower   109772        10158764
  Jbuilder 2.2.11              7.570    ±13.2%      44.96x slower   68659         4765953
  AMS 0.9.3                   34.802    ±14.4%      9.78x slower    31433         981155
  Presenters                  60.465    ±16.5%      5.63x slower    34408         960494
  ApiView                    340.337    ±28.2%                      810           329486

```

## Extending

Data for the benchmarks is stored in [lib/models](lib/models).
