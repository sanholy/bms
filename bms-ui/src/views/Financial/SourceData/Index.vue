<template>
  <div class="financial-query-page">
    <el-tabs v-model="tabsIndex" type="card" @tab-click="handleClick">
      <el-tab-pane v-for="(item,index) in tabs" :key="index" :label="item.label" :name="item.cpt"></el-tab-pane>
    </el-tabs>
    <components :is="tabsIndex" />
  </div>
</template>

<script>
import { sstorage } from '@/tools/utils';
import Tab1 from './Tab1';
import Tab2 from './Tab2';
import Tab3 from './Tab3';
import Tab4 from './Tab4';
import Tab5 from './Tab5';

export default {
  components: { Tab1, Tab2, Tab3, Tab4, Tab5 },
  data() {
    return {
      tabs: [
        { label: '七分钱交广科技银联对账源数据表', cpt: 'Tab1' },
        { label: '银联对账源数据表', cpt: 'Tab2' },
        { label: '交广科技对账源数据表', cpt: 'Tab3' },
        { label: '七分钱银联对账源数据表', cpt: 'Tab4' },
        { label: '中信对账源数据表', cpt: 'Tab5' }
      ],
      tabsIndex: 'Tab1'
    };
  },
  created() {
    this.initTabIndex();
  },
  beforeDestroy() {
    sstorage.set('queryCurrentIndex', '');
  },
  methods: {
    handleClick() {
      sstorage.set('queryCurrentIndex', this.tabsIndex);
    }
  }
};
</script>

<style lang="scss">
.financial-query-page {
  overflow: auto;
}
</style>