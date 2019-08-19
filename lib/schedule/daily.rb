require 'savon'

class DailyScheduler
  def self.run_daily_tasks
    puts "***"
    puts "Daily tasks"
    p Time.now.strftime("%d/%m/%Y %H:%M:%S")
    self.getDataFromAPI
    puts "***"
  end
  
  def self.run_import_tasks
    puts "***"
    puts "Import tasks"
    p Time.now.strftime("%d/%m/%Y %H:%M:%S")
    puts "***"
  end

  def self.getDataFromAPI
    client = Savon.client(wsdl: 'http://www.chemspider.com/MassSpecAPI.asmx?WSDL')
    # client = Savon.client(wsdl: 'http://demo.mpm.es/VisualSEGServicios/Polizas.asmx?WSDL')

    puts "===="
    p client.operations
    puts "===="

    response = client.call(:get_databases)
    if response.success?
      puts "=== get databases ==="
      puts "response.body"
      data = response.to_array(:get_databases_response, :get_databases_result, :string)
      if(data)
        puts data[5]
      end
      puts "====================="
    end

    response = client.call(:search_by_mass, message:{ mass: 2.2 })
    puts "=== search_by_mass Teste ==="
    data = response.to_array(:get_databases_response, :get_databases_result, :string)
    if(data)
      puts "data"
      puts data
      puts data[5]
    else
      puts "No data"
    end
    puts "====================="

    response = client.call(:search_by_mass, message:{ mass: 2.2, range: 2 })
    if response.success?
      puts "=== search_by_mass ==="
      puts "response.body"
      puts response.body[:search_by_mass_response][:search_by_mass_result][:string][2]
      puts "======================"
    end
  end
end