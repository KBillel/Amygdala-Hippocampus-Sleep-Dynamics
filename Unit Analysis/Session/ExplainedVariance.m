function [EV REV] = ExplainedVariance(corrMatrixTemplate,corrMatrixPre,corrMatrixPost)
    rPrePost = corrcoef(corrMatrixPre,corrMatrixPost,'rows','complete'); rPrePost = rPrePost(1,2);
    rTemplatePre = corrcoef(corrMatrixTemplate,corrMatrixPre,'rows','complete');rTemplatePre = rTemplatePre(1,2);
    rTemplatePost = corrcoef(corrMatrixTemplate,corrMatrixPost,'rows','complete');rTemplatePost = rTemplatePost(1,2);
    
    EV  = ((rTemplatePost-rTemplatePre*rPrePost)/sqrt((1-rTemplatePre^2)*(1-rPrePost^2)))^2; 
    REV = ((rTemplatePre-rTemplatePost*rPrePost)/sqrt((1-rTemplatePost^2)*(1-rPrePost^2)))^2;
end

