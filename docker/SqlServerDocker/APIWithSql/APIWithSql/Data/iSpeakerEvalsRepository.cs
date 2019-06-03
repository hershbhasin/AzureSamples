using System.Threading.Tasks;
using System.Collections.Generic;
using APIWithSql.Models;

namespace APIWithSql.Data
{
    public interface iSpeakerEvalsRepository
    {

        Task<SpeakerEval> AddAsync(SpeakerEval item);
        IEnumerable<SpeakerEval> GetAll();
        Task<SpeakerEval> FindAsync(int id);
        Task RemoveAsync(int id);
        Task UpdateAsync(SpeakerEval se);
    }
}
