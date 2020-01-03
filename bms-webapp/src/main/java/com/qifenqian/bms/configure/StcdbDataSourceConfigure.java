package com.qifenqian.bms.configure;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

import com.alibaba.druid.pool.DruidDataSource;

/**
 * 数据源配置， 暂时不使用
 *
 * @author xun.sun
 */
@Configuration
@MapperScan(
    basePackages = "com.qifenqian.bms",
    sqlSessionFactoryRef = "stcdbSqlSessionFactory", annotationClass = MapperScan.class)
public class StcdbDataSourceConfigure {

  @ConfigurationProperties("spring.datasource.stcdb")
  @Bean(name = "stcdbDataSource")
  public DruidDataSource stcdbDataSource() {
    return new DruidDataSource();
  }

  @Bean(name = "stcdbTransactionManager")
  public DataSourceTransactionManager combinedmasterTransactionManager() {
    return new DataSourceTransactionManager(stcdbDataSource());
  }

  @Bean(name = "stcdbSqlSessionFactory")
  public SqlSessionFactory masterSqlSessionFactory(
      @Qualifier("stcdbDataSource") DataSource dataSource) throws Exception {
    final SqlSessionFactoryBean sessionFactoryBean = new SqlSessionFactoryBean();
    sessionFactoryBean.setDataSource(dataSource);
    /*sessionFactoryBean.setMapperLocations(
    new PathMatchingResourcePatternResolver().getResources(MAPPER));*/
    return sessionFactoryBean.getObject();
  }

  /*  @Bean("combinedmasterMaperScan")
  public MapperScannerConfigurer combinedmasterMapperScan() {
    MapperScannerConfigurer bean = new MapperScannerConfigurer();
    bean.setSqlSessionFactoryBeanName("combinedmasterSqlSessionFactory");
    bean.setBasePackage("com.qifenqian.bms");
    bean.setAnnotationClass(com.qifenqian.bms.common.annotation.MapperScanCombinedmaster.class);
    return bean;
  }*/
}
