$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), 'lib')))

require 'benchmark/ips'
require 'allocation_stats'
require 'json_serialization_benchmark'
require 'terminal-table'

require 'serializers/event_summary_serializer'
require 'serializers/team_serializer'
require 'serializers/basketball/event_serializer'
require 'active_model/serializer/version'

require 'presenters/event_summary_presenter'
require 'presenters/team_presenter'
require 'presenters/basketball/event_presenter'

require 'multi_json'
require 'oj'
Oj.mimic_JSON() # Use OJ for benchmarks using #to_json
MultiJson.use(:oj) # Use OJ by default from multi_json

module SerializationBenchmark
  collection_size = 100
  rabl_view_path  = File.expand_path(File.dirname(__FILE__) + '/lib/rabl/views')

  event = EventFactory.build_event
  team  = event.home_team

  event_collection = collection_size.times.map { event }
  team_collection  = collection_size.times.map { team }

  class Benchmark::Suite
    def self.current
      self.new
    end

    def quiet?
      false # bug in 2.1.1 of Benchmark::IPS
    end

    def warming(label, sec); end
    def warmup_stats(time, cycles); end
    def running(label, sec); end
    def add_report(rep, location); end
    def display; end
  end

  module Benchie
    def self.start
      @start_time ||= Time.now
    end

    def self.end
      # Don't memoize, use the last call to this method
      @end_time = Time.now
    end

    def self.print_suite_banner
      puts "\n\nUsing Ruby version: #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
    end

    def self.print_section_separator(section_title)
      puts "\n\n#{section_title}:\n\n"
    end

    # Basically our own version of calling this process with a `time`
    def self.print_suite_summary
      total_seconds = @end_time - @start_time
      display_seconds = total_seconds % 60
      display_minutes = total_seconds / 60 % 60
      puts "Total wall clock time: %dm%2.3fs" % [display_minutes, display_seconds]
    end

    def self.measure(benchmark_name)
      job = nil
      report = Benchmark.ips do |benchmark|
        yield(benchmark)
        job = benchmark
      end

      # collect allocation data, needs ruby >= 2.1
      items_allocations = job.list.each_with_object({}) do |item, hash|
        hash[item.label] = AllocationStats.new(burn: 5).trace { item.action.call }
      end

      warmups = job.timing.each_with_object({}) { |kv, h| h[kv.first.label] = kv.last }
      entries = report.entries.sort_by(&:ips)
      rows = entries.map do |e|
        [
          e.label,
          Benchmark::IPS::Helpers.scale(warmups[e.label]),
          Benchmark::IPS::Helpers.scale(e.ips),
          "±%4.1f%%" % (100.0 * e.ips_sd.to_f / e.ips),
          Benchmark::IPS::Helpers.scale(e.iterations),
          e != entries.last ? "%.2fx slower" % (entries.last.ips.to_f / e.ips) : '', # blank out the fastest comparison, guaranteed to be 1x
          items_allocations[e.label].allocations.all.size,
          items_allocations[e.label].allocations.bytes.to_a.inject(&:+)
        ]
      end

      headings = [benchmark_name, "Warmups\n(i/100ms)", "Iterations\n(i/s)", "Iterations\n(std dev %)", 'Total Iterations', 'Comparison', 'Allocations', 'Memsize']
      puts Terminal::Table.new(headings: headings, rows: rows, style: { border_y: ' ', border_i: ' ', border_x: '' })
    end
  end

  Benchie.print_suite_banner
  Benchie.start
  # MEMBER TESTS
  Benchie.print_section_separator("Member tests")

  # ULTRA SIMPLE
  Benchie.measure("Ultra Simple: Member") do |b|
    b.config(time: 10, warmup: 2)

    #TODO labels must be unique
    b.report('%-36.36s' % "RABL #{Rabl::VERSION}") do
      Rabl.render(team, 'teams/item', view_path: rabl_view_path, format: :json)
    end

    b.report('%-36.36s' % "AMS #{ActiveModel::Serializer::VERSION}") do
      TeamSerializer.new(team).to_json
    end

    b.report('%-36.36s' % "Presenters") do
      TeamPresenter.new(team).to_json
    end

    b.report('%-36.36s' % "ApiView") do
      ApiView::Engine.render(team, nil, :format => "json")
    end

    b.report('%-36.36s' % "Jbuilder #{Gem.loaded_specs['jbuilder'].version.to_s}") do
      Jbuilder.render('teams/show', locals: { team: team }, layout: false, format: :json)
    end
  end

  # SIMPLE
  Benchie.measure("Simple: Member") do |b|
    b.config(time: 10, warmup: 2)

    b.report('%-36.36s' % "RABL #{Rabl::VERSION}") do
      Rabl.render(event, 'events/item', view_path: rabl_view_path, format: :json)
    end

    b.report('%-36.36s' % "AMS #{ActiveModel::Serializer::VERSION}") do
      EventSummarySerializer.new(event).to_json
    end

    b.report('%-36.36s' % "Presenters") do
      EventSummaryPresenter.new(event).to_json
    end

    b.report('%-36.36s' % "ApiView") do
      ApiView::Engine.render(event, nil, :format => "json", :use => EventSummaryApiView)
    end

    b.report('%-36.36s' % "Jbuilder #{Gem.loaded_specs['jbuilder'].version.to_s}") do
      Jbuilder.render('events/show', locals: { event: event }, layout: false, format: :json)
    end
  end

  # COMPLEX
  Benchie.measure("Complex: Member") do |b|
    b.config(time: 10, warmup: 2)

    b.report('%-36.36s' % "RABL #{Rabl::VERSION}") do
      Rabl.render(event, 'basketball/events/show', view_path: rabl_view_path, format: :json)
    end

    b.report('%-36.36s' % "AMS #{ActiveModel::Serializer::VERSION}") do
      Basketball::EventSerializer.new(event).to_json
    end

    b.report('%-36.36s' % "Presenters") do
      Basketball::EventPresenter.new(event).to_json
    end

    b.report('%-36.36s' % "ApiView") do
      ApiView::Engine.render(event, nil, :format => "json", :use => BasketballEventApiView)
    end

    b.report('%-36.36s' % "Jbuilder #{Gem.loaded_specs['jbuilder'].version.to_s}") do
      Jbuilder.render('basketball/events/show', locals: { event: event }, layout: false, format: :json)
    end
  end

  # COLLECTION TESTS
  Benchie.print_section_separator("Collection tests")

  # ULTRA SIMPLE
  Benchie.measure("Ultra Simple: Collection") do |b|
    b.config(time: 10, warmup: 2)

    b.report('%-40.40s' % "RABL #{Rabl::VERSION}") do
      Rabl.render(team_collection, 'teams/index', view_path: rabl_view_path, format: :json)
    end

    b.report('%-40.40s' % "AMS #{ActiveModel::Serializer::VERSION}") do
      ActiveModel::ArraySerializer.new(team_collection, each_serializer: TeamSerializer).to_json
    end

    b.report('%-40.40s' % "Presenters") do
      team_collection.map { |team| TeamPresenter.new(team).as_json }.to_json
    end

    b.report('%-40.40s' % "ApiView") do
      ApiView::Engine.render(team_collection, nil, :format => "json")
    end

    b.report('%-40.40s' % "Jbuilder #{Gem.loaded_specs['jbuilder'].version.to_s}") do
      Jbuilder.render('teams/index', locals: { teams: team_collection }, layout: false, format: :json)
    end
  end

  # SIMPLE
  Benchie.measure("Simple: Collection") do |b|
    b.config(time: 10, warmup: 2)

    b.report('%-40.40s' % "RABL #{Rabl::VERSION}") do
      Rabl.render(event_collection, 'events/index', view_path: rabl_view_path, format: :json)
    end

    b.report('%-40.40s' % "AMS #{ActiveModel::Serializer::VERSION}") do
      ActiveModel::ArraySerializer.new(event_collection, each_serializer: EventSummarySerializer).to_json
    end

    b.report('%-40.40s' % "Presenters") do
      event_collection.map { |event| EventSummaryPresenter.new(event).as_json }.to_json
    end

    b.report('%-40.40s' % "ApiView") do
      ApiView::Engine.render(event_collection, nil, :format => "json", :use => EventSummaryApiView)
    end

    b.report('%-40.40s' % "Jbuilder #{Gem.loaded_specs['jbuilder'].version.to_s}") do
      Jbuilder.render('events/index', locals: { events: event_collection }, layout: false, format: :json)
    end
  end

  # COMPLEX
  Benchie.measure("Complex: Collection") do |b|
    b.config(time: 10, warmup: 2)

    b.report('%-40.40s' % "RABL #{Rabl::VERSION}") do
      Rabl.render(event_collection, 'basketball/events/index', view_path: rabl_view_path, format: :json)
    end

    b.report('%-40.40s' % "AMS #{ActiveModel::Serializer::VERSION}") do
      ActiveModel::ArraySerializer.new(event_collection, each_serializer: Basketball::EventSerializer).to_json
    end

    b.report('%-40.40s' % "Presenters") do
      event_collection.map { |event| Basketball::EventPresenter.new(event).as_json }.to_json
    end

    b.report('%-40.40s' % "ApiView") do
      ApiView::Engine.render(event_collection, nil, :format => "json", :use => BasketballEventApiView)
    end

    b.report('%-40.40s' % "Jbuilder #{Gem.loaded_specs['jbuilder'].version.to_s}") do
      Jbuilder.render('basketball/events/index', locals: { events: event_collection }, layout: false, format: :json)
    end
  end

  Benchie.end
  Benchie.print_suite_summary
end
