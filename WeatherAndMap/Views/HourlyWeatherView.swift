//
//  HourlyWeatherView.swift
//  WeatherAndMap
//
//  Created by 佐藤幸久 on 2025/02/16.
//

import SwiftUI

struct HourlyWeatherView: View {
    let defaultDateStr = "----年‐‐月‐‐日"
    @ObservedObject var weatherVM: WeatherViewModel
    
    var body: some View {
        if let forecastsDay = weatherVM.forecast?.forecastsDay {
            ForEach(forecastsDay, id: \.self) {forecastDay in
                let hourlyDisplayForecasts = forecastDay.hour.compactMap { HourlyForecast in
                    HourlyForecast.toDisplayFormat(hourlyForecast: HourlyForecast)
                }
                VStack {
                    
                    Divider()
                    
                    Text(hourlyDisplayForecasts.first?.date ?? defaultDateStr)
                        .padding(.vertical, 5)
                    
                    HStack(spacing: 5) {
                        HourlyWeatherHeader()
                        ScrollView(.horizontal) {
                            HStack(spacing: 5) {
                                ForEach(hourlyDisplayForecasts) { hourlyDisplayForecast in
                                    // MARK: 1時間分の表示
                                    VStack(spacing: 10) {
                                        // 時刻
                                        Text(hourlyDisplayForecast.time)
                                            .font(.subheadline)
                                            .scaledToFit()
                                        
                                        // 天気アイコン
                                        AsyncImageView(urlStr: "https:\(hourlyDisplayForecast.weatherIcon)")
                                            .frame(maxWidth:64, maxHeight: 64)
                                            .scaledToFit()
                                            
                                        // 気温
                                        Text(hourlyDisplayForecast.temperature, format: .number)
                                            .font(.subheadline)
                                        
                                        // 降水確率
                                        Text(hourlyDisplayForecast.chanceOfRain, format: .number)
                                            .font(.subheadline)
                                    }
                                    .frame(width: ScreenInfo.width / 9)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
// MARK: - 時間毎の予報のヘッダー
struct HourlyWeatherHeader: View {
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("時刻(時)")
                .font(.caption)
            
            Text("天気")
                .font(.caption)
                .frame(maxHeight: 40)
            
            Text("気温(℃)")
                .font(.caption)
            
            
            Text("降水確率(%)")
                .font(.caption2)
        }
        .frame(width: 65, height: 180)
        .background(Color.blue.opacity(0.1))
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    @Previewable @StateObject var weatherVM = WeatherViewModel()
    // 八幡平市大更の緯度・経度
    let lat: Double = 39.91167
    let lon: Double = 141.093459
    
    HourlyWeatherView(weatherVM: weatherVM)
        .onAppear {
            weatherVM.request3DaysForecast(lat: lat, lon: lon)
        }
}

#Preview {
    ContentView()
}
