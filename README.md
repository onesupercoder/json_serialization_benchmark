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


  Ultra Simple: Member        Iterations    Iterations   Comparison      Allocations   Memsize
                              (i/s)         std dev %

  Jbuilder 2.2.11              3.608k       ±11.7%       16.74x slower   181           8640
  RABL 0.11.6                  5.977k       ± 7.6%       10.11x slower    97           6969
  AMS 0.9.3                   17.207k       ± 8.5%       3.51x slower     63           1715
  Presenters                  58.504k       ±11.4%       1.03x slower     24            650
  Kartograph 0.2.2            60.053k       ±10.3%       1.01x slower     12            850
  ApiView                     60.416k       ± 8.7%                        12            842


  Simple: Member              Iterations    Iterations   Comparison      Allocations   Memsize
                              (i/s)         std dev %

  RABL 0.11.6                  1.075k       ±12.9%       31.58x slower   534           44241
  Jbuilder 2.2.11              1.308k       ±14.1%       25.95x slower   464           27536
  AMS 0.9.3                    6.498k       ± 9.7%       5.22x slower    163            4863
  Presenters                  16.227k       ± 6.6%       2.09x slower     98            2918
  Kartograph 0.2.2            19.638k       ± 9.5%       1.73x slower     27            1974
  ApiView                     33.932k       ±17.2%                        15            1862


  Complex: Member             Iterations    Iterations   Comparison       Allocations   Memsize
                              (i/s)         std dev %

  RABL 0.11.6                 484.440       ±12.8%       139.08x slower   1130          101977
  Jbuilder 2.2.11             719.501       ± 9.5%       93.64x slower     829           52404
  AMS 0.9.3                     3.467k      ± 7.2%       19.43x slower     324           10026
  Presenters                    6.691k      ±12.2%       10.07x slower     201            7395
  ApiView                      21.603k      ±21.0%       3.12x slower       17            3667
  Kartograph 0.2.2             67.375k      ±14.8%                          12             656



Collection tests:


  Ultra Simple: Collection        Iterations    Iterations   Comparison      Allocations   Memsize
                                  (i/s)         std dev %

  RABL 0.11.6                       73.562    ±10.9%         39.94x slower   7660          648077
  Jbuilder 2.2.11                   76.512    ±13.1%         38.40x slower   6433          517065
  AMS 0.9.3                        229.424    ±10.9%         12.81x slower   5333          150055
  Presenters                       687.029    ±11.8%          4.28x slower   3508           67594
  Kartograph 0.2.2                 911.278    ±15.4%          3.22x slower    607           48578
  ApiView                            2.938k   ±26.1%                          112           46986


  Simple: Collection              Iterations    Iterations   Comparison      Allocations   Memsize
                                  (i/s)         std dev %

  Jbuilder 2.2.11                    8.868    ±11.3%         86.40x slower   61353         4277513
  RABL 0.11.6                       11.782    ±17.0%         65.04x slower   50964         4364195
  AMS 0.9.3                          7.726    ±13.3%         11.31x slower   15333          464855
  Presenters                       151.952    ± 7.9%          5.04x slower   16108          380794
  Kartograph 0.2.2                 223.890    ±14.3%          3.42x slower    2107          160978
  ApiView                          766.258    ±23.4%                           610          148986


  Complex: Collection             Iterations    Iterations   Comparison      Allocations   Memsize
                                  (i/s)         std dev %

  RABL 0.11.6                        4.985    ±20.1%         71.71x slower   109772        10158764
  Jbuilder 2.2.11                    8.111    ±12.3%         44.07x slower    68659         4765953
  AMS 0.9.3                         36.066    ±13.9%         9.91x slower     31433          981155
  Presenters                        61.468    ±16.3%         5.82x slower     34408          960494
  Kartograph 0.2.2                 112.438    ±17.8%         3.18x slower      6207          379078
  ApiView                          357.465    ±28.8%                            810          329486

```

## Extending

Data for the benchmarks is stored in [lib/models](lib/models).
