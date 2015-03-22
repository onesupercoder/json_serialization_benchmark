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

(Condensed to not show user, system, or total timings, run the benchmarks to see them.)

```
Using Ruby version: 2.1.5-p273


Member tests:


                                        Iterations      Iterations     Comparison   Allocations  Memsize
                                             (i/s)     (std dev %)
Jbuilder 2.2.11 Ultra Simple: Member      3.672k          ± 8.0%    16.19x slower   181         8640
RABL 0.11.6 Ultra Simple: Member          5.859k          ± 7.2%    10.15x slower    97         6969
AMS 0.9.3 Ultra Simple: Member           15.165k          ±13.3%     3.92x slower    63         1715
Presenters Ultra Simple: Member          56.148k          ±11.4%     1.06x slower    24          650
ApiView Ultra Simple: Member             59.457k          ± 7.7%                     12          842


                                        Iterations      Iterations     Comparison   Allocations  Memsize
                                             (i/s)     (std dev %)
RABL 0.11.6 Simple: Member                1.085k          ±13.8%    31.30x slower   534        44241
Jbuilder 2.2.11 Simple: Member            1.200k          ±17.3%    28.32x slower   464        27536
AMS 0.9.3 Simple: Member                  6.206k          ±11.9%     5.47x slower   163         4863
Presenters Simple: Member                13.405k          ±16.3%     2.53x slower    98         2918
ApiView Simple: Member                   33.971k          ±19.1%                     15         1862


                                        Iterations      Iterations     Comparison   Allocations  Memsize
                                             (i/s)     (std dev %)
RABL 0.11.6 Complex: Member             520.344           ± 9.0%    45.38x slower   1130      101977
Jbuilder 2.2.11 Complex: Member         697.827           ±13.5%    33.84x slower    829       52404
AMS 0.9.3 Complex: Member                 3.436k          ± 5.9%     6.87x slower    324       10026
Presenters Complex: Member                7.222k          ± 5.4%     3.27x slower    201        7395
ApiView Complex: Member                  23.614k          ±20.7%                      17        3667



Collection tests:


                                            Iterations    Iterations     Comparison   Allocations    Memsize
                                                 (i/s)   (std dev %)
RABL 0.11.6 Ultra Simple: Collection         75.516         ± 9.3%    40.61x slower   7660            648077
Jbuilder 2.2.11 Ultra Simple: Collection     84.983         ± 8.2%    36.08x slower   6433            517065
AMS 0.9.3 Ultra Simple: Collection          236.878         ± 7.2%    12.95x slower   5333            150055
Presenters Ultra Simple: Collection         711.300         ± 4.4%     4.31x slower   3508             67594
ApiView Ultra Simple: Collection              3.066k        ±25.0%                     112             46986


                                             Iterations   Iterations     Comparison   Allocations    Memsize
                                                  (i/s)  (std dev %)
Jbuilder 2.2.11 Simple: Collection            9.300         ±10.8%    83.49x slower   61353          4277513
RABL 0.11.6 Simple: Collection               11.723         ± 8.5%    66.23x slower   50961          4364099
AMS 0.9.3 Simple: Collection                 75.030         ± 5.3%    10.35x slower   15333           464855
Presenters Simple: Collection               150.221         ± 7.3%     5.17x slower   16108           380794
ApiView Simple: Collection                  776.379         ±19.4%                      610           148986


                                             Iterations   Iterations     Comparison   Allocations    Memsize
                                                  (i/s)  (std dev %)
RABL 0.11.6 Complex: Collection               5.298         ±18.9%    69.27x slower   109770        10158657
Jbuilder 2.2.11 Complex: Collection           8.432         ± 0.0%    43.52x slower    68659         4765953
AMS 0.9.3 Complex: Collection                36.882         ± 5.4%     9.95x slower    31433          981155
Presenters Complex: Collection               63.148         ± 9.5%     5.81x slower    34408          960494
ApiView Complex: Collection                 366.966         ±26.7%                       810          329486

```

## Extending

Data for the benchmarks is stored in [lib/models](lib/models).

## Furtherwork
* Switch out bixby-bench for benchmark-ips w/ allocation stats to get standard deviation.
