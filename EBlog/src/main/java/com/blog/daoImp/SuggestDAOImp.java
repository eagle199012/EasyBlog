package com.blog.daoImp;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.blog.dao.SuggestDAO;
import com.blog.model.BllSuggest;
import com.blog.utils.HibernateUtils;

/**
 * @author：Tim
 * @date：2018年1月14日 下午8:53:30
 * @description：TODO
 */
@Repository
public class SuggestDAOImp implements SuggestDAO {

	@Override
	public List<BllSuggest> getSuggestListByUser(String userId) {
		List<BllSuggest> list = HibernateUtils.queryListParam(BllSuggest.class,
				"select * from bll_suggest where user='" + userId + "'");

		return list;
	}

	@Override
	public boolean deleteSuggest(String toDeleteIds) {
		String[] deleteidArray = toDeleteIds.split(",");

		StringBuilder strSqlBlder = new StringBuilder();
		strSqlBlder.append("delete from bll_suggest where id in (");

		for (int i = 0; i < deleteidArray.length; i++) {
			strSqlBlder.append("'");
			strSqlBlder.append(deleteidArray[i]);
			strSqlBlder.append("'");
			strSqlBlder.append(",");
		}
		strSqlBlder.deleteCharAt(strSqlBlder.length() - 1);
		strSqlBlder.append(")");

		return HibernateUtils.executeSql(strSqlBlder.toString());
	}

}
